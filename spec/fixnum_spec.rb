require 'spec_helper'

describe "Count number length" do

  it "Fixnum#length" do
    expect(1.length).to eq 1
    expect(5.length).to eq 1
    expect(9.length).to eq 1
    expect(90.length).to eq 2
    expect(900.length).to eq 3
    expect(9000.length).to eq 4
    expect(-9000.length).to eq 4
    # alias
    expect(-9000.digits).to eq 4
  end

  it "Bignum#length" do
    expect(12356469787881584554556.length).to eq 23
    expect(-12356469787881584554556.length).to eq 23
    # alias
    expect(-12356469787881584554556.digits).to eq 23
  end

  it "Float#length" do
    expect{ 0.0.length }.to raise_error(ArgumentError)
    expect{ 1.0.length }.to raise_error(ArgumentError)
    expect{ -1.0.length }.to raise_error(ArgumentError)
    expect{ 3.14.length }.to raise_error(ArgumentError)
    expect{ 12356469.987.length }.to raise_error(ArgumentError)
    # alias
    expect{ 12356469.987.digits }.to raise_error(ArgumentError)
  end

  it "BigDecimal#length" do
    expect{ 1265437718438866624512.123.length }.to raise_error(ArgumentError)
    expect{ -1265437718438866624512.123.length }.to raise_error(ArgumentError)
    expect{ 0.9999999999999062.length }.to raise_error(ArgumentError)
    expect{ -0.9999999999999062.length }.to raise_error(ArgumentError)
    # alias
    expect{ -0.9999999999999062.digits }.to raise_error(ArgumentError)
  end
  
  it "Fixnum#percentage_off" do
    expect(1.percentage_off(10)).to eq 0.9
    expect(10.percentage_off(10)).to eq 9.0
    expect(25.percentage_off(5)).to eq 23.75
    expect(76.percentage_off(40)).to eq 45.6
  end
  
  it "Bignum#percentage_off" do
    expect(1.0.percentage_off(10)).to eq 0.9
    expect(10.4.percentage_off(10)).to eq 9.360000000000001
    expect(25.2.percentage_off(5)).to eq 23.939999999999998
    expect(76.6.percentage_off(40)).to eq 45.959999999999994
  end
  
  it "BigDecimal#percentage_off" do
    expect(12654377184.123123.percentage_off(10)).to eq 11388939465.710812
    expect(123.129405.percentage_off(25)).to eq 92.34705375
  end

end
