require 'spec_helper'

describe String do

  it '#nl2br' do
  end

  it "#keyify" do
    # expect(SizedQueue.keyify).to eq :sized_queue
    # expect('FooBarBaz'.keyify).to eq :foo_bar_baz
    # expect(:FooBarBaz.keyify).to eq :foo_bar_baz
    # expect('(Foo*&Bar!Baz?'.keyify).to eq :foo_bar_baz
    # expect('!@#$Foo0987'.keyify).to eq :foo
    # expect{ '!@#$%^'.keyify }.to raise_error(ArgumentError)
    # expect{ '12345678'.keyify }.to raise_error(ArgumentError)
  end

  it '#unwrap' do
    expect( "_____foo____".unwrap('_') ).to eq 'foo'
    expect( "__break__foo____".unwrap('_') ).to eq 'break_foo'
    expect( "__'''foo__'".unwrap('_\'') ).to eq 'foo'
    expect( "__ ___foo__ __".unwrap('_ ', whitespace: false) ).to eq 'foo'
    expect( "__0 1__foo__8__".unwrap('0-9_ ', regex: true) ).to eq 'foo'
    expect( "__0 1__foo__8__".unwrap('0-9_ ', regex: true, whitespace: false) ).to eq 'foo'
    expect( "__0 1__foo__8__".unwrap('0-9_', regex: true, whitespace: false) ).to eq ' 1__foo'
    expect( "000000".unwrap('0') ).to eq ''
    expect( "000000".unwrap(0) ).to eq ''
  end

end
