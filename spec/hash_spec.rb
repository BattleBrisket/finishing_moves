require 'spec_helper'

describe Hash do

  let :test_hash do
    { :foo => :bar, :baz => :bin, :flo => :bie }
  end

  it "#delete!" do
    expect(test_hash.delete!(:bogus)).to eq({ :foo => :bar, :baz => :bin, :flo => :bie })
    expect(test_hash.delete!(:baz)).to eq({ :foo => :bar, :flo => :bie })
  end

  it "#delete_each" do
    expect(test_hash.delete_each(:bogus, :bar)).to eq nil
    expect(test_hash).to eq({ :foo => :bar, :baz => :bin, :flo => :bie })
    expect(test_hash.delete_each(:flo)).to eq({ :flo => :bie })
    expect(test_hash).to eq({ :foo => :bar, :baz => :bin })
    expect(test_hash.delete_each(:foo, :baz, :bogus)).to eq({ :foo => :bar, :baz => :bin })
    expect(test_hash).to eq({ })
  end

  it "#delete_each!" do
    expect(test_hash.delete_each!(:bogus, :bar)).to eq({ :foo => :bar, :baz => :bin, :flo => :bie })
    expect(test_hash.delete_each!(:flo)).to eq({ :foo => :bar, :baz => :bin })
    expect(test_hash.delete_each!(:bogus, :flo, :foo)).to eq({ :baz => :bin })
    expect(test_hash.delete_each!(:baz)).to eq({ })
  end

  it '#sample' do
    string_keys = {
      "Eastern Time (US & Canada)"  => "America/New_York",
      "Central Time (US & Canada)"  => "America/Chicago",
      "Mountain Time (US & Canada)" => "America/Denver",
      "Pacific Time (US & Canada)"  => "America/Los_Angeles",
      "Indiana (East)"              => "America/Indiana/Indianapolis",
      "Arizona"                     => "America/Phoenix",
    }
    sample_1 = string_keys.sample
    expect(sample_1).to be_a Hash
    expect(sample_1.size).to eq 1
    expect(sample_1 <= string_keys).to be_true

    sample_2 = string_keys.sample(2)
    expect(sample_2).to be_a Hash
    expect(sample_2.size).to eq 2
    expect(sample_2 <= string_keys).to be_true

    sample_4 = string_keys.sample(4)
    expect(sample_4).to be_a Hash
    expect(sample_4.size).to eq 4
    expect(sample_4 <= string_keys).to be_true

    sample_3 = test_hash.sample(1)
    expect(sample_3).to be_a Hash
    expect(sample_3.size).to eq 1
    expect(sample_3 <= test_hash).to be_true
  end

  it '#sample returns when empty' do
    expect( {}.sample ).to eq nil
    expect( {}.sample(1) ).to eq({})
    expect( {}.sample(3) ).to eq({})
  end

  it '#sample optional :random keyword' do
    smp = test_hash.sample(random: Random.new(1))
    expect(smp).to be_a Hash
    expect(smp.size).to eq 1
    expect(smp <= test_hash).to be_true

    smp2 = test_hash.sample(2, random: Random.new(1))
    expect(smp2).to be_a Hash
    expect(smp2.size).to eq 2
    expect(smp2 <= test_hash).to be_true
  end

end
