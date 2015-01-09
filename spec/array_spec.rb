require 'spec_helper'

describe Array do

  let :sages do
    ['Rauru', 'Saria', 'Darunia', 'Princess Ruto', 'Nabooru', 'Impa', 'Zelda']
  end

  it '#fill_hash' do
    sages_hash = sages.fill_hash
    i = 0
    sages.each do |sage|
      expect(sages_hash[i]).to eq sage
      i += 1
    end

    sages_hash = sages.fill_hash(22)
    i = 22
    sages.each do |sage|
      expect(sages_hash[i]).to eq sage
      i += 1
    end
  end

  it '#fill_hash_keys' do
    sages_hash = sages.fill_hash_keys
    sages.each do |sage|
      expect(sages_hash[sage]).not_to eq nil
      expect(sages_hash[sage]).to eq 0
    end

    sages_hash = sages.fill_hash_keys('foobar')
    sages.each do |sage|
      expect(sages_hash[sage]).not_to eq nil
      expect(sages_hash[sage]).to eq 'foobar'
    end
  end

end
