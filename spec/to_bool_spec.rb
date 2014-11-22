require 'spec_helper'

describe "Boolean typecasting" do

  it "String#to_bool" do
    data = {
      true  => %w(1 true t yes y on TRUE T YES Y ON tRUe),
      false => %w(0 false f no n off FALSE F NO N OFF fALsE),
    }
    data.each do |truth, strings|
      strings.each { |str| expect(str.to_bool).to eq truth }
    end
    expect("".to_bool).to eq false
    expect(" ".to_bool).to eq false
    expect("  ".to_bool).to eq false
  end

  it "Fixnum#to_bool" do
    expect(1.to_bool).to eq true
    expect(0.to_bool).to eq false
    expect{ 2.to_bool }.to raise_error(ArgumentError)
    expect{ 10.to_bool }.to raise_error(ArgumentError)
    expect{ 1234.to_bool }.to raise_error(ArgumentError)
    expect{ -1.to_bool }.to raise_error(ArgumentError)
    expect{ -2.to_bool }.to raise_error(ArgumentError)
  end

  context "TrueClass" do
    it "#to_bool" do
      expect(true.to_bool).to eq true
    end
    it "#to_i" do
      expect(true.to_i).to eq 1
    end
  end

  context "FalseClass" do
    it "#to_bool" do
      expect(false.to_bool).to eq false
    end
    it "#to_i" do
      expect(false.to_i).to eq 0
    end
  end

  context "NilClass" do
    it "#to_bool" do
      expect(nil.to_bool).to eq false
    end
    it "#to_i" do
      expect(nil.to_i).to eq 0
    end
  end

end
