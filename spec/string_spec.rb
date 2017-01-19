require 'spec_helper'

describe String do

  it '#dedupe' do
    expect('___foo___'.dedupe('_')).to eq '_foo_'
    expect('---foo---'.dedupe('-')).to eq '-foo-'
    expect('___foo---'.dedupe('_-')).to eq '_foo-'
    expect('___foo__bar_baz--bing'.dedupe('_')).to eq '_foo_bar_baz--bing'
    expect('foo'.dedupe('o')).to eq 'fo'
    expect('foo'.dedupe('O')).to eq 'foo'
    expect('[[foo]]]'.dedupe('[]')).to eq '[foo]'
    expect('/crazy//concatenated////file/path'.dedupe('/')).to eq '/crazy/concatenated/file/path'

    # make sure our use of gsub! isn't screwing us over
    orig = '___foo___'
    modified = orig.dedupe('_')
    expect(modified).to eq '_foo_'
    expect(orig).to eq '___foo___'
  end

  it '#dedupe!' do
    str = '___foo___'
    str.dedupe!('_')
    expect(str).to eq '_foo_'
  end

  it '#strip_all (incl _strip_all_prep)' do
    expect('___foo___'.strip_all).to eq 'foo'
    expect('---foo---'.strip_all).to eq 'foo'
    expect('-_-foo-_-'.strip_all).to eq 'foo'
    expect('_-_8-foo-8_-_'.strip_all).to eq '8-foo-8'
    expect('0123456789-foo-9876543210'.strip_all('0-9')).to eq '-foo-'
    expect('0123-foo-3210'.strip_all('0-9-')).to eq 'foo'
    expect('0123-foo-3210'.strip_all('a-z')).to eq '0123-foo-3210'
    expect('foo-314-foo'.strip_all('a-z')).to eq '-314-'
    expect('foo-314-foo'.strip_all('a-z-')).to eq '314'
    expect('foo-314-foo'.strip_all('A-Z')).to eq 'foo-314-foo'
    expect('FOO-314-FOO'.strip_all('A-Z')).to eq '-314-'
    expect('FOO  314  FOO'.strip_all('A-Z')).to eq '314'

    expect('abcdefghijklmnopqrstuvwxyz'.strip_all('a-z')).to eq ''
    expect('ABCDEFGHIJKLMNOPQRSTUVWXYZ'.strip_all('A-Z')).to eq ''
    expect('ABCDEFGHIJKLM   FOO   NOPQRSTUVWXYZ'.strip_all('A-Z')).to eq ''

    expect('000000'.strip_all('0')).to eq ''
    expect('[[000]]'.strip_all('[0]')).to eq ''
    expect('. $ ^ { [ ( | ) * + ? \ '.strip_all('. $ ^ { [ ( | ) * + ? \ ')).to eq ''
    expect('/[a|valid|regex]+/'.strip_all('/[]+')).to eq 'a|valid|regex'

    expect('_1 0__spaces_incl__0 1_'.strip_all('0-9_')).to eq 'spaces_incl'
    expect('  _spaces_incl_  '.strip_all).to eq 'spaces_incl'

    expect("__'''foo__'".strip_all('_\'') ).to eq 'foo'
    expect('abcdefghijklm   foo123   nopqrstuvwxyz'.strip_all('a-z0-9')).to eq ''
    expect('hello world'.strip_all('a-z')).to eq ''

    expect{'bad call'.strip_all(101)}.to raise_error(ArgumentError)
  end

  it '#strip_all!' do
    str = '___foo___'
    str.strip_all!
    expect(str).to eq 'foo'
  end

  it '#lstrip_all' do
    expect('___foo___'.lstrip_all).to eq 'foo___'
  end

  it '#lstrip_all!' do
    str = '___foo___'
    str.lstrip_all!
    expect(str).to eq 'foo___'
  end

  it '#rstrip_all' do
    expect('___foo___'.rstrip_all).to eq '___foo'
  end

  it '#rstrip_all!' do
    str = '___foo___'
    str.rstrip_all!
    expect(str).to eq '___foo'
  end

  it '#match?' do
    expect('hello'.match?('he')).to be true
    expect('hello'.match?('he', 1)).to be false
    expect('hello'.match?('o')).to be true
    expect('hello'.match?('ol')).to be false
    expect('hello'.match?('(.)')).to be true
    expect('hello'.match?(/(.)/)).to be true
    expect('hello'.match?('xx')).to be false
  end

  it '#remove_whitespace' do
    expect('   a b c d     e'.remove_whitespace).to eq 'abcde'
    expect(' [  foo ]   '.remove_whitespace).to eq '[foo]'
    expect('   '.remove_whitespace).to eq ''
    expect('. $ ^ { [ ( | ) * + ? \ '.remove_whitespace).to eq '.$^{[(|)*+?\\'
    expect('a b c d e'.remove_whitespace('+')).to eq 'abcde'
    expect('a  b c d e'.remove_whitespace('+')).to eq 'abcde'
    expect('a b c d e'.remove_whitespace('__')).to eq 'abcde'
  end

  it '#remove_whitespace!' do
    str = '   a b c d     e'
    str.remove_whitespace!
    expect(str).to eq 'abcde'
  end

  it '#replace_whitespace' do
    expect('   a b c d     e'.replace_whitespace).to eq 'abcde'
    expect('a b c d e'.replace_whitespace('+')).to eq 'a+b+c+d+e'
    expect('a  b c d e'.replace_whitespace('+')).to eq 'a++b+c+d+e'
    expect('a b c d e'.replace_whitespace('__')).to eq 'a__b__c__d__e'
  end

  it '#replace_whitespace!' do
    str = 'a b c d e'
    str.replace_whitespace!('-')
    expect(str).to eq 'a-b-c-d-e'
  end

  it '#nl2br' do
    expect("\n".nl2br).to       eq "<br />\n"
    expect("\n\r".nl2br).to     eq "<br />\n"
    expect("\r\n".nl2br).to     eq "<br />\n"
    expect("\n\r\n".nl2br).to   eq "<br />\n<br />\n"
    expect("\r\n\r\n".nl2br).to eq "<br />\n<br />\n"
    expect("\r\r\n".nl2br).to   eq "<br />\n<br />\n"
    expect("\r\r".nl2br).to     eq "<br />\n<br />\n"
    expect("\n\r\r".nl2br).to   eq "<br />\n<br />\n"

    expect("Let's play Global Thermonuclear War.\n\r".nl2br).to eq "Let's play Global Thermonuclear War.<br />\n"
    expect("A strange game.\n\nThe only winning move is not to play.\r\nHow about a nice game of chess?\r".nl2br).
      to eq "A strange game.<br />\n<br />\nThe only winning move is not to play.<br />\nHow about a nice game of chess?<br />\n"
  end

  it "#newline_to" do
    expect("\n".newline_to).to       eq " "
    expect("\n\r".newline_to).to     eq " "
    expect("\r\n".newline_to).to     eq " "
    expect("\n\r\n".newline_to).to   eq "  "
    expect("\r\n\r\n".newline_to).to eq "  "
    expect("\r\r\n".newline_to).to   eq "  "
    expect("\r\r".newline_to).to     eq "  "
    expect("\n\r\r".newline_to).to   eq "  "

    # replacements should end up as strings
    expect("\n".newline_to(:bar)).to eq 'bar'
    expect("\n\n".newline_to('+')).to eq '++'
    expect("\n\n".newline_to(0)).to eq '00'
    expect("\n\n".newline_to(true)).to eq 'truetrue'

    expect("Let's play Global Thermonuclear War.\n\r".newline_to).to eq "Let's play Global Thermonuclear War. "
    expect("A strange game.\n\nThe only winning move is not to play.\r\nHow about a nice game of chess?\r".newline_to).
      to eq "A strange game.  The only winning move is not to play. How about a nice game of chess? "
  end

  it '#keyify' do
    expect(Integer.keyify).to eq :integer
    expect(Math::DomainError.keyify).to eq :math_domain_error
    expect('FooBarBaz'.keyify).to eq :foo_bar_baz
    expect(:FooBarBaz.keyify).to eq :foo_bar_baz
    expect("Foo-Bar'Baz".keyify).to eq :foo_bar_baz
    expect('(Foo*&Bar!Baz?'.keyify).to eq :foo_bar_baz
    expect('1234FooBAR'.keyify).to eq :foo_bar
    expect('!@#$Foo0987'.keyify).to eq :foo0987
    expect('!@#$%^'.keyify).to eq nil
    expect('12345678'.keyify).to eq nil
    expect("Bill O'Shea".keyify).to eq :bill_o_shea
    expect("Bill O Shea".keyify).to eq :bill_o_shea
    expect("Bill O   Shea".keyify).to eq :bill_o_shea

    # make sure we're not performing in place
    str = 'FooBarBaz'
    expect(str.keyify).to eq :foo_bar_baz
    expect(str).to eq 'FooBarBaz'

    # should work on frozen values
    expect('FooBarBaz'.freeze.keyify).to eq :foo_bar_baz
  end

  it '#keyify!' do
    expect{ '!@#$%^'.keyify! }.to raise_error(ArgumentError)
    expect{ '12345678'.keyify! }.to raise_error(ArgumentError)
  end

  it "dedupe + remove_whitespace" do
    expect('1   2 3 4  5'.dedupe(' ').remove_whitespace('+')).to eq '12345'
    expect('1   2 3 4  5'.dedupe(' ').replace_whitespace('+')).to eq '1+2+3+4+5'
  end

  it '#slugify' do
    expect(Integer.slugify).to eq 'integer'
    expect(Math::DomainError.slugify).to eq 'math-domain-error'
    expect('FooBarBaz'.slugify).to eq 'foo-bar-baz'
    expect(:FooBarBaz.slugify).to eq 'foo-bar-baz'
    expect("Foo-Bar'Baz".slugify).to eq 'foo-bar-baz'
    expect('(Foo*&Bar!Baz?'.slugify).to eq 'foo-bar-baz'
    expect('!@#$Foo0987'.slugify).to eq 'foo0987'
    expect('!@#$%^'.slugify).to eq nil
    expect("Bill O'Shea".slugify).to eq 'bill-o-shea'
    expect("Bill O Shea".slugify).to eq 'bill-o-shea'
    expect("Bill O   Shea".slugify).to eq 'bill-o-shea'

    # make sure we're not performing in place
    str = 'FooBarBaz'
    expect(str.slugify).to eq 'foo-bar-baz'
    expect(str).to eq 'FooBarBaz'

    # we permit leading numbers, unlike keyify
    expect('!1234FooBAR'.slugify).to eq '1234-foo-bar'
    expect('1234FooBAR'.slugify).to eq '1234-foo-bar'
    expect('12345678'.slugify).to eq '12345678'

    # should work on frozen values
    expect('FooBarBaz'.freeze.slugify).to eq 'foo-bar-baz'
  end

  it '#slugify!' do
    expect{ '!@#$%^'.slugify! }.to raise_error(ArgumentError)
    expect{ '12345678'.slugify! }.not_to raise_error
  end

  it '#numeric?' do
    expect("42".numeric?).to be true
    expect("-42".numeric?).to be true
    expect("1.2".numeric?).to be true
    expect("0".numeric?).to be true
    expect("1.2e34".numeric?).to be true
    expect("1_000".numeric?).to be true
    expect("".numeric?).to be false
    expect(" ".numeric?).to be false
    expect("a".numeric?).to be false
    expect("-".numeric?).to be false
    expect(".".numeric?).to be false
    expect("_".numeric?).to be false
    expect("1.2.3".numeric?).to be false
  end

end
