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
    expect(test_hash.delete_each(:bogus)).to eq nil
    expect(test_hash).to eq({ :foo => :bar, :baz => :bin, :flo => :bie })
    expect(test_hash.delete_each(:flo)).to eq({ :flo => :bie })
    expect(test_hash).to eq({ :foo => :bar, :baz => :bin })
    expect(test_hash.delete_each(:foo, :baz, :bogus)).to eq({ :foo => :bar, :baz => :bin })
    expect(test_hash).to eq({ })
  end

  it "#delete_each!" do
    expect(test_hash.delete_each!(:bogus)).to eq({ :foo => :bar, :baz => :bin, :flo => :bie })
    expect(test_hash.delete_each!(:flo)).to eq({ :foo => :bar, :baz => :bin })
    expect(test_hash.delete_each!(:bogus, :flo, :foo)).to eq({ :baz => :bin })
    expect(test_hash.delete_each!(:baz)).to eq({ })
  end

end
