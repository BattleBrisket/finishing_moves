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
    test_hash = {
      "Eastern Time (US & Canada)"  => "America/New_York",
      "Central Time (US & Canada)"  => "America/Chicago",
      "Mountain Time (US & Canada)" => "America/Denver",
      "Pacific Time (US & Canada)"  => "America/Los_Angeles",
      "Indiana (East)"              => "America/Indiana/Indianapolis",
      "Arizona"                     => "America/Phoenix",
    }
    test_hash_clone = test_hash.dup
    test_hash.sample

  end

end
