require 'spec_helper'

describe Enumerable do

  let :test_array do
    [
      {:foo => 1, :bar => 5, :baz =>  9},
      {:foo => 2, :bar => 6, :baz => 10},
      {:foo => 3, :bar => 7, :baz => 11},
      {:foo => 4, :bar => 8, :baz => 12},
    ]
  end

  it "#key_map" do
    expect(test_array.key_map :foo).to eq([1, 2, 3, 4])
    expect(test_array.key_map :bar).to eq([5, 6, 7, 8])
    expect(test_array.key_map :baz).to eq([9, 10, 11, 12])
  end

  context "#key_map_reduce" do
    it "default behavior" do
      expect(test_array.key_map_reduce :foo).to eq(10)
      expect(test_array.key_map_reduce :bar).to eq(26)
      expect(test_array.key_map_reduce :baz).to eq(42)
    end
    it "with method override" do
      expect(test_array.key_map_reduce :foo, :*).to eq(24)
      expect(test_array.key_map_reduce :bar, :*).to eq(1680)
      expect(test_array.key_map_reduce :baz, :*).to eq(11880)
    end
    it "with block" do
      actual = test_array.key_map_reduce(:bar, "") { |memo,x| memo + "#{x**2}," }
      expect(actual).to eq("25,36,49,64,")
    end
  end

end
