require 'spec_helper'

describe Array do

  let :sages do
    ['Rauru', 'Saria', 'Darunia', 'Princess Ruto', 'Impa', 'Nabooru', 'Zelda']
  end

  it '#to_indexed_hash' do
    expect { sages.to_indexed_hash("e") }.to raise_error(ArgumentError)
    sages_hash = sages.to_indexed_hash
    i = 0
    sages.each do |sage|
      expect(sages_hash[i]).to eq sage
      i += 1
    end

    sages_hash = sages.to_indexed_hash(22)
    i = 22
    sages.each do |sage|
      expect(sages_hash[i]).to eq sage
      i += 1
    end
  end

  it '#to_hash_values <#to_indexed_hash behaviour>' do
    sages_hash = sages.to_hash_values
    i = 0
    sages.each do |sage|
      expect(sages_hash[i]).to eq sage
      i += 1
    end

    block = proc { |key| key + 1 }
    sages_hash = sages.to_hash_values 0, &block
    i = 0
    sages.each do |sage|
      expect(sages_hash[i]).to eq sage
      i += 1
    end

    sages_hash = sages.to_hash_values(22)
    i = 22
    sages.each do |sage|
      expect(sages_hash[i]).to eq sage
      i += 1
    end
  end

  it '#to_hash_values' do
    block = proc { |key| key + 3 }
    sages_hash = sages.to_hash_values 0, &block
    i = 0
    sages.each do |sage|
      expect(sages_hash[i]).to eq sage
      i += 3
    end

    sages_hash = sages.to_hash_values 22, &block
    i = 22
    sages.each do |sage|
      expect(sages_hash[i]).to eq sage
      i += 3
    end

    # alias check
    expect(sages.to_hash_as_values(22, &block)).to eq sages_hash

    elements = SageElements.new
    sages_hash = sages.to_hash_values(elements.first_key) do |key|
      elements.next_key(key)
    end
    expect(sages_hash[:light]).to eq sages[0]
    expect(sages_hash[:forest]).to eq sages[1]
    expect(sages_hash[:fire]).to eq sages[2]
    expect(sages_hash[:water]).to eq sages[3]
    expect(sages_hash[:shadow]).to eq sages[4]
    expect(sages_hash[:spirit]).to eq sages[5]
    expect(sages_hash[:time]).to eq sages[6]
  end

  it '#to_hash_keys' do
    sages_hash = sages.to_hash_keys
    # alias check
    expect(sages.to_hash_as_keys).to eq sages_hash

    sages.each do |sage|
      expect(sages_hash[sage]).to eq 0
    end

    sages_hash = sages.to_hash_keys('foobar')
    sages.each do |sage|
      expect(sages_hash[sage]).to eq 'foobar'
    end

    sages_hash = sages.to_hash_keys { |key| key + "1" }
    sages.each do |sage|
      expect(sages_hash[sage]).to eq sage + "1"
    end
  end

  it '#to_sym_strict' do
    test = ['FOO', 'bar', :baz]
    expect(test.to_sym_strict).to eq [:FOO, :bar, :baz]
    expect(test).to eq ['FOO', 'bar', :baz]
    expect{ [1].to_sym_strict }.to raise_error NoMethodError
  end

  it '#to_sym_strict!' do
    test = ['FOO', 'bar', :baz]
    expect(test.to_sym_strict!).to eq [:FOO, :bar, :baz]
    expect(test).to eq [:FOO, :bar, :baz]
    expect{ [1].to_sym_strict! }.to raise_error NoMethodError
  end

  it '#to_sym_loose' do
    test = ['FOO', 'bar', :baz, 1, {bat: 'bat'}, /hay/]
    expect(test.to_sym_loose).to eq [:FOO, :bar, :baz, 1, {bat: 'bat'}, /hay/]
    expect(test).to eq ['FOO', 'bar', :baz, 1, {bat: 'bat'}, /hay/]
  end

  it '#to_sym_loose!' do
    test = ['FOO', 'bar', :baz, 1, {bat: 'bat'}, /hay/]
    expect(test.to_sym_loose!).to eq [:FOO, :bar, :baz, 1, {bat: 'bat'}, /hay/]
    expect(test).to eq [:FOO, :bar, :baz, 1, {bat: 'bat'}, /hay/]
  end

end

class SageElements

  def initialize
    @keys = {
      :first  => :light,
      :light  => :forest,
      :forest => :fire,
      :fire   => :water,
      :water  => :shadow,
      :shadow => :spirit,
      :spirit => :time,
      :time   => :first,
    }
  end

  def first_key
    @keys[:first]
  end

  def next_key(pointer)
    @keys[pointer]
  end

end
