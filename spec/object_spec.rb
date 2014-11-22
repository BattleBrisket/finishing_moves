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
    expect(chain{ var.transmogrify }).to eq nil

    c = C.new
    b = B.new c
    a = A.new b
    expect(a.b.c.hello).to eq "Hello, world!"
    b.c = nil
    expect(nil_chain{a.b.c.hello}).to eq nil
  end

  it "#bool_chain" do
    expect(bool_chain{bogus_variable}).to eq false
    var = true
    expect(bool_chain{var}).to eq true
    expect(bool_chain{ var.transmogrify }).to eq false
  end

  it "#class_exists?" do
    expect(class_exists? :Symbol).to eq true
    expect(class_exists? :Symbology).to eq false
    expect(class_exists? 'Symbol').to eq true
    expect(class_exists? 'Symbology').to eq false
    expect(class_exists? :Array).to eq true
    expect(class_exists? :aRRay).to eq false
    binding.pry
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

end

# test classes

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
