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

    # should return a modified object, leaving original intact
    newline = "\n"
    bar = newline.newline_to(:bar)
    expect(newline).to eq "\n"
    expect(bar).to eq 'bar'

    expect("Let's play Global Thermonuclear War.\n\r".newline_to).to eq "Let's play Global Thermonuclear War. "
    expect("A strange game.\n\nThe only winning move is not to play.\r\nHow about a nice game of chess?\r".newline_to).
      to eq "A strange game.  The only winning move is not to play. How about a nice game of chess? "
  end

  it "#newline_to!" do
    var = "\n"
    var.newline_to! :foo
    expect(var).to eq 'foo'
  end

  keyify_sets = [
    [Integer, :integer],
    [Math::DomainError, :math_domain_error],
    ['FooBarBaz', :foo_bar_baz],
    [:FooBarBaz, :foo_bar_baz],
    ["Foo-Bar'Baz", :foo_bar_baz],
    ['(Foo*&Bar!Baz?', :foo_bar_baz],
    ['1234FooBAR', :foo_bar],
    ['!@#$Foo0987', :foo0987],
    ["Bill O'Shea", :bill_o_shea],
    ["Bill O Shea", :bill_o_shea],
    ["Bill O   Shea", :bill_o_shea],
  ]

  it '#keyify' do
    keyify_sets.each do |set|
      inc, out = set
      expect(inc.keyify).to eq out
    end
    expect('!@#$%^'.keyify).to eq nil
    expect('12345678'.keyify).to eq nil
    # make sure we're not performing in place
    str = 'FooBarBaz'
    expect(str.keyify).to eq :foo_bar_baz
    expect(str).to eq 'FooBarBaz'
    # should work on frozen values
    expect('FooBarBaz'.freeze.keyify).to eq :foo_bar_baz
  end

  it '#keyify!' do
    keyify_sets.each do |set|
      inc, out = set
      expect(inc.keyify!).to eq out
    end
    expect{ '!@#$%^'.keyify! }.to raise_error(ArgumentError)
    expect{ '12345678'.keyify! }.to raise_error(ArgumentError)
  end

  it "dedupe + remove_whitespace" do
    expect('1   2 3 4  5'.dedupe(' ').remove_whitespace('+')).to eq '12345'
    expect('1   2 3 4  5'.dedupe(' ').replace_whitespace('+')).to eq '1+2+3+4+5'
  end

  slugify_sets = [
    [Integer, 'integer'],
    [Math::DomainError, 'math-domain-error'],
    ['FooBarBaz', 'foo-bar-baz'],
    [:FooBarBaz, 'foo-bar-baz'],
    ["Foo-Bar'Baz", 'foo-bar-baz'],
    ['(Foo*&Bar!Baz?', 'foo-bar-baz'],
    ["Bill O'Shea", 'bill-o-shea'],
    ["Bill O Shea", 'bill-o-shea'],
    ["Bill O   Shea", 'bill-o-shea'],
  ]

  it '#slugify' do
    slugify_sets.each do |set|
      inc, out = set
      expect(inc.slugify).to eq out
    end
    expect('!@#$Foo0987'.slugify).to eq 'foo0987'
    expect('!@#$%^'.slugify).to eq nil
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
    slugify_sets.each do |set|
      inc, out = set
      expect(inc.slugify!).to eq out
    end
    expect{ '!@#$%^'.slugify! }.to raise_error(ArgumentError)
    expect{ '12345678'.slugify! }.not_to raise_error
  end

  it '#to_uuid' do
    str = "5062754996b140c8b5dde7ffc23376a1"
    expect(str.to_uuid).to eq "50627549-96b1-40c8-b5dd-e7ffc23376a1"
    # too long
    expect{ (str + '1').to_uuid }.to raise_error(ArgumentError)
    # not hex
    expect{ (str[0,31] + 'k').to_uuid }.to raise_error(ArgumentError)
    # just bad
    expect{ ("just some writing 123!").to_uuid }.to raise_error(ArgumentError)

    formatted_uuid = "5a658838-7aa4-488c-98f1-21805a5d2021"
    expect(formatted_uuid.to_uuid).to eq formatted_uuid
    # Only dashes are accepted as separators
    expect{ formatted_uuid.gsub('-', ' ').to_uuid }.to raise_error(ArgumentError)
    expect{ formatted_uuid.gsub('-', '.').to_uuid }.to raise_error(ArgumentError)

    random_uuid = SecureRandom.uuid
    no_dashes = random_uuid.delete('-')
    expect(no_dashes.to_uuid).to eq random_uuid
  end

end
