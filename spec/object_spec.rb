require 'spec_helper'

describe Object do

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

  it "#is_an?" do
    a = [1,2,3]
    expect(a.is_an?(Array)).to eq true
    expect(a.is_an?(Hash)).to eq false
  end

  it "#is_not_a?" do
    a = [1,2,3]
    expect(a.is_not_a?(Array)).to eq false
    expect(a.is_not_a?(Hash)).to eq true
    expect(a.is_not_an?(Array)).to eq false
    expect(a.is_not_an?(Hash)).to eq true
  end

  it "#true?" do
    expect(true.true?).to eq true
    expect(false.true?).to eq false
    expect(nil.true?).to eq false
    expect([:ar, :ray].true?).to eq false
    expect({ha: :sh}.true?).to eq false
    expect('string'.true?).to eq false
    expect(:symbol.true?).to eq false
  end

  it "#false?" do
    expect(false.false?).to eq true
    expect(true.false?).to eq false
    expect(nil.false?).to eq false
    expect([:ar, :ray].false?).to eq false
    expect({ha: :sh}.false?).to eq false
    expect('string'.false?).to eq false
    expect(:symbol.false?).to eq false
  end

  it "#bool?" do
    expect(true.bool?).to eq true
    expect(false.bool?).to eq true
    expect(nil.bool?).to eq false
    expect('string'.bool?).to eq false
    expect(:symbol.bool?).to eq false
    expect(1.bool?).to eq false
    expect(0.bool?).to eq false
  end

  it "#is_one_of?" do
    expect(nil.is_one_of? NilClass).to eq true
    expect(nil.is_one_of? TrueClass, FalseClass, NilClass).to eq true
    expect(nil.is_one_of? TrueClass, FalseClass).to eq false
    expect(1.is_one_of? Integer, String).to eq true
    expect('1'.is_one_of? Integer, String).to eq true
    expect('1'.is_one_of? Integer, Float).to eq false
    expect(1.1.is_one_of? Integer, Float).to eq true
    expect(1.1.is_one_of? String, Float).to eq true
    expect('1.1'.is_one_of? String, Float).to eq true
    expect(:symbol.is_one_of? String, Symbol, Float).to eq true
    expect(:symbol.is_one_of? String, Float).to eq false
    expect(:symbol.is_one_of? String, Symbol).to eq true
    expect(:symbol.is_one_of? String, Float, Object).to eq true
  end

  it "#true_?" do
    expect(true.true_?).to eq true
    expect(false.true_?).to eq false
    expect{ nil.true_? }.to raise_error(RuntimeError)
    expect{ 1.true_? }.to raise_error(RuntimeError)
    expect{ [:ar, :ray].true_? }.to raise_error(RuntimeError)
    expect{ {ha: :sh}.true_? }.to raise_error(RuntimeError)
    expect{ 'string'.true_? }.to raise_error(RuntimeError)
    expect{ :symbol.true_? }.to raise_error(RuntimeError)
  end

  it "#false_?" do
    expect(false.false_?).to eq true
    expect(true.false_?).to eq false
    expect{ nil.false_? }.to raise_error(RuntimeError)
    expect{ 0.false_? }.to raise_error(RuntimeError)
    expect{ [:ar, :ray].false_? }.to raise_error(RuntimeError)
    expect{ {ha: :sh}.false_? }.to raise_error(RuntimeError)
    expect{ 'string'.false_? }.to raise_error(RuntimeError)
    expect{ :symbol.false_? }.to raise_error(RuntimeError)
  end


end
