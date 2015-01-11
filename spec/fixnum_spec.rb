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

end
