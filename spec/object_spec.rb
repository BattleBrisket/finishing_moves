require 'spec_helper'

describe Object do

  it "#nil_chain" do
    expect(nil_chain{bogus_variable}).to eq nil
    expect(nil_chain{bogus_hash[:foo]}).to eq nil
    params = { :foo => 'bar' }
    expect(nil_chain{ params[:bogus_key] }).to eq nil
    expect(nil_chain{ params[:foo] }).to eq 'bar'
    var = 'a simple string'
    expect(nil_chain{ var.transmogrify }).to eq nil

    c = C.new
    b = B.new c
    a = A.new b
    expect(a.b.c.hello).to eq "Hello, world!"
    b.c = nil
    expect(nil_chain{a.b.c.hello}).to eq nil
    a = nil
    expect(nil_chain{a.b.c.hello}).to eq nil

    expect( nil_chain(true) { bogus_variable } ).to equal true
    expect( nil_chain(false) { bogus_variable } ).to equal false
    expect( nil_chain('gotcha!') { bogus_variable } ).to eq 'gotcha!'
    expect( nil_chain('gotcha!') { params[:bogus_key] } ).to eq 'gotcha!'
    expect( nil_chain('gotcha!') { params[:foo] } ).to eq 'bar'

    # alias
    expect(method_chain{bogus_variable}).to eq nil
  end

  it "#bool_chain" do
    expect(bool_chain{bogus_variable}).to equal false
    var = true
    expect(bool_chain{var}).to equal true
    var = 'foo'
    expect(bool_chain{var}).to eq 'foo'
    result = bool_chain{ var.transmogrify }
    expect(result).to equal false
  end

  it "#class_exists?" do
    expect(class_exists? :Symbol).to eq true
    expect(class_exists? :Symbology).to eq false
    expect(class_exists? 'Symbol').to eq true
    expect(class_exists? 'Symbology').to eq false
    expect(class_exists? :Array).to eq true
    expect(class_exists? :aRRay).to eq false
    expect(class_exists? :ARRAY).to eq false
  end

  it "#not_nil?" do
    var = nil
    expect(var.not_nil?).to eq false
    var = 'foobar'
    expect(var.not_nil?).to eq true
  end

  it "#same_as" do
    expect(:symbol.same_as 'symbol').to eq true
    expect('symbol'.same_as :symbol).to eq true
    expect('1'.same_as 1).to eq true
    expect(2.same_as '2').to eq true
    expect(3.same_as 3).to eq true
    expect(:symbol.same_as :SYMBOL).to eq false

    user = User.new
    expect(:faceless_one.same_as(user)).to eq true
    expect(user.same_as(:faceless_one)).to eq true
    expect(user.same_as(:FACELESS_ONE)).to eq false
  end

  it "#cascade" do
    expect(test_cascade).to be_nil
    expect(test_cascade('step1')).to eq 1
    expect(test_cascade('step2')).to eq 2
    expect(test_cascade('step3')).to eq 3
    expect(test_cascade('foobar')).to eq 4
  end

  it "#keyify" do
    expect(SizedQueue.keyify).to eq :sized_queue
    expect('FooBarBaz'.keyify).to eq :foo_bar_baz
    expect(:FooBarBaz.keyify).to eq :foo_bar_baz
    expect('(Foo*&Bar!Baz?'.keyify).to eq :foo_bar_baz
    expect('!@#$Foo0987'.keyify).to eq :foo
    expect{ '!@#$%^'.keyify }.to raise_error(ArgumentError)
    expect{ '12345678'.keyify }.to raise_error(ArgumentError)
  end

end

# some small test fixtures

class A
  attr_accessor :b
  def initialize(b)
    @b = b
  end
end

class B
  attr_accessor :c
  def initialize(c)
    @c = c
  end
end

class C
  def hello
    "Hello, world!"
  end
end

class User
  attr_writer :handle

  def handle
    @handle || "faceless_one"
  end

  def to_s
    handle.to_s
  end
end

def test_cascade(trigger = nil)
  ultimate_value = nil
  cascade do
    break if trigger.nil?
    ultimate_value = 1
    break if trigger == 'step1'
    ultimate_value = 2
    break if trigger == 'step2'
    ultimate_value = 3
    break if trigger == 'step3'
    ultimate_value = 4
  end
  return ultimate_value
end
