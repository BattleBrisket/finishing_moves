require 'spec_helper'

describe Array do

  let :sages do
    ['Rauru', 'Saria', 'Darunia', 'Princess Ruto', 'Nabooru', 'Impa', 'Zelda']
  end

  it '#to_indexed_hash' do
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

  it '#to_hash_as_values <#to_indexed_hash behaviour>' do
    block = proc { |key| key + 1 }
    sages_hash = sages.to_hash_as_values 0, &block
    # alias check
    _ = sages.use_as_values_for_hash 0, &block
    __ = sages.use_as_values 0, &block
    expect((sages_hash == _) && (sages_hash == __)).to eq true

    i = 0
    sages.each do |sage|
      expect(sages_hash[i]).to eq sage
      i += 1
    end

    sages_hash = sages.to_hash_as_values(22)
    i = 22
    sages.each do |sage|
      expect(sages_hash[i]).to eq sage
      i += 1
    end
  end

  it '#to_hash_as_values' do
    block = proc { |key| key + 3 }
    sages_hash = sages.to_hash_as_values 0, &block
    # alias check
    _ = sages.use_as_values_for_hash 0, &block
    __ = sages.use_as_values 0, &block
    expect((sages_hash == _) && (sages_hash == __)).to eq true

    i = 0
    sages.each do |sage|
      expect(sages_hash[i]).to eq sage
      i += 3
    end

    sages_hash = sages.to_hash_as_values 22, &block
    i = 22
    sages.each do |sage|
      expect(sages_hash[i]).to eq sage
      i += 3
    end
  end

  it '#to_hash_as_keys' do
    sages_hash = sages.to_hash_as_keys
    # alias check
    _ = sages.use_as_keys_for_hash
    __ = sages.use_as_keys
    expect((sages_hash == _) && (sages_hash == __)).to eq true

    sages.each do |sage|
      expect(sages_hash[sage]).to eq nil
    end

    sages_hash = sages.to_hash_as_keys('foobar')
    sages.each do |sage|
      expect(sages_hash[sage]).to eq 'foobar'
    end

    sages_hash = sages.to_hash_as_keys { |key| key + "1" }
    sages.each do |sage|
      expect(sages_hash[sage]).to eq sage + "1"
    end
  end

end
