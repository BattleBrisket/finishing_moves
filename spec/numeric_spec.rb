require 'spec_helper'

describe "Numeric methods" do

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

  it "Fixnum#subtract_percent" do
    expect(1.subtract_percent(10)).to eq 0.9
    expect(10.subtract_percent(10)).to eq 9.0
    expect(25.subtract_percent(5)).to eq 23.75
    expect(76.subtract_percent(40)).to eq 45.6
    expect(76.percentage_off(40)).to eq 45.6
    expect(98786.percentage_off(100)).to eq 0
  end

  it "Bignum#subtract_percent" do
    expect(12356469787881584554556.subtract_percent(10)).to eq 1.1120822809093428e+22
    expect(12356469787881584554556.subtract_percent(99)).to eq 1.2356469787881585e+20
    expect(12356469787881584554556.percentage_off(99.99999)).to eq 1235646979180369.8
  end

  it "Float#subtract_percent" do
    expect(1.0.subtract_percent(10)).to eq 0.9
    expect(10.4.subtract_percent(10)).to eq 9.360000000000001
    expect(25.2.subtract_percent(5)).to eq 23.939999999999998
    expect(76.6.subtract_percent(40)).to eq 45.959999999999994
    expect(1.0.percentage_off(10)).to eq 0.9
  end

  it "BigDecimal#subtract_percent" do
    expect(12654377184.123123.subtract_percent(10)).to eq 11388939465.710812
    expect(123.129405.subtract_percent(25)).to eq 92.34705375
    expect(123.129405.percentage_off(25)).to eq 92.34705375
  end


  it "Fixnum#add_percent" do
    expect(1.add_percent(10)).to eq 1.1
    expect(10.add_percent(10)).to eq 11.0
    expect(25.add_percent(5)).to eq 26.25
    expect(76.add_percent(40)).to eq 106.4
    expect(76.markup_by_percent(40)).to eq 106.4
    expect(200.markup_by_percent(100)).to eq 400
  end

  it "Bignum#add_percent" do
    expect(12356469787881584554556.add_percent(10)).to eq 1.3592116766669745e+22
    expect(12356469787881584554556.markup_by_percent(10)).to eq 1.3592116766669745e+22
  end

  it "Float#add_percent" do
    expect(1.5.add_percent(100)).to eq 3.0
    expect(10.4.add_percent(10)).to eq 11.440000000000001
    expect(25.2.add_percent(5)).to eq 26.46
    expect(76.6.add_percent(40)).to eq 107.24
    expect(1.5.markup_by_percent(100)).to eq 3.0
  end

  it "BigDecimal#add_percent" do
    expect(12654377184.123123.add_percent(10)).to eq 13919814902.535435
    expect(123.129405.add_percent(25)).to eq 153.91175625
    expect(123.129405.markup_by_percent(25)).to eq 153.91175625
  end

end
