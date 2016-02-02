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
    a = Array
    expect(a.is_an?(Array)).to be_true
    expect(a.is_an?(Hash)).to be_false
  end

  it "#is_not_a?" do
    a = Array
    expect(a.is_not_a?(Array)).to be_false
    expect(a.is_not_a?(Hash)).to be_true
    expect(a.is_not_an?(Array)).to be_false
    expect(a.is_not_an?(Hash)).to be_true
  end

end
