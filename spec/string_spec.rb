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

    expect('abcdefghijklmnopqrstuvwxyz'.strip_all('a-z')).to eq ''
    expect('ABCDEFGHIJKLMNOPQRSTUVWXYZ'.strip_all('A-Z')).to eq ''

    expect('000000'.strip_all('0')).to eq ''
    expect('[[000]]'.strip_all('[0]')).to eq ''
    expect('. $ ^ { [ ( | ) * + ? \ '.strip_all('. $ ^ { [ ( | ) * + ? \ ')).to eq ''

    expect('_1 0__spaces_incl__0 1_'.strip_all('0-9_')).to eq 'spaces_incl'
    expect('  _spaces_incl_  '.strip_all).to eq 'spaces_incl'

    expect("__'''foo__'".strip_all('_\'') ).to eq 'foo'

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
  end

  it '#remove_whitespace' do
    expect('   a b c d     e'.remove_whitespace).to eq 'abcde'
    expect(' [  foo ]   '.remove_whitespace).to eq '[foo]'
    expect('   '.remove_whitespace).to eq ''
    expect('. $ ^ { [ ( | ) * + ? \ '.remove_whitespace).to eq '.$^{[(|)*+?\\'
  end

  it '#remove_whitespace!' do
    str = '   a b c d     e'
    str.remove_whitespace!
    expect(str).to eq 'abcde'
  end

  it '#replace_whitespace' do
  end

  it '#nl2br' do
  end

  it '#keyify' do
    expect(SizedQueue.keyify).to eq :thread_sized_queue
    expect(Integer.keyify).to eq :integer
    expect(Math::DomainError.keyify).to eq :math_domain_error
    expect('FooBarBaz'.keyify).to eq :foo_bar_baz
    expect(:FooBarBaz.keyify).to eq :foo_bar_baz
    expect('(Foo*&Bar!Baz?'.keyify).to eq :foo_bar_baz
    expect('!@#$Foo0987'.keyify).to eq :foo0987
    expect('!@#$%^'.keyify).to eq nil
    expect('12345678'.keyify).to eq nil
  end

  it '#keyify!' do
    expect{ '!@#$%^'.keyify! }.to raise_error(ArgumentError)
    expect{ '12345678'.keyify! }.to raise_error(ArgumentError)
  end

end
