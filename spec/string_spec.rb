require 'spec_helper'

describe String do

  it '#nl2br' do
  end

  it '#keyify' do
    expect(SizedQueue.keyify).to eq :sized_queue
    expect('FooBarBaz'.keyify).to eq :foo_bar_baz
    expect(:FooBarBaz.keyify).to eq :foo_bar_baz
    expect('(Foo*&Bar!Baz?'.keyify).to eq :foo_bar_baz
    expect('!@#$Foo0987'.keyify).to eq :foo
    expect{ '!@#$%^'.keyify }.to raise_error(ArgumentError)
    expect{ '12345678'.keyify }.to raise_error(ArgumentError)
  end

  it '#strip_all (incl _strip_all_prep)' do
    expect('___foo___'.strip_all).to eq 'foo'
    expect("___foo___\n".strip_all).to eq 'foo'
    expect("___foo___\n\r".strip_all).to eq 'foo'
    expect('---foo---'.strip_all).to eq 'foo'
    expect('-_-foo-_-'.strip_all).to eq 'foo'
    expect('_-_8-foo-8_-_'.strip_all).to eq '8-foo-8'

    expect('0123456789-foo-9876543210'.strip_all('0-9')).to eq '-foo-'
    expect('0123-foo-3210'.strip_all('0-9-')).to eq 'foo'
    expect('0123-foo-3210'.strip_all('a-z')).to eq '0123--3210'
    expect('0123-foo-3210'.strip_all('a-z-')).to eq '01233210'
    expect('0123-foo-3210'.strip_all('A-Z')).to eq '0123-foo-3210'
    expect('0123-FOO-3210'.strip_all('A-Z')).to eq '0123--3210'

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
    str.lstrip_all!
    expect(str).to eq '___foo'
  end

  it '#dedupe' do
    expect('___foo__bar_baz--bing'.dedupe('_')).to eq 'foo_bar_baz--bing'
  end

  it '#match?' do
  end

  it '#remove_whitespace' do
  end

  it '#replace_whitespace' do
  end

end
