require 'spec_helper'

describe FinishingMovesFiscalLogic do

  it "#fiscal_quarter" do
    expect(Time.method_defined? :fiscal_quarter).to be true
    expect(Date.method_defined? :fiscal_quarter).to be true
    expect(DateTime.method_defined? :fiscal_quarter).to be true

    quarters = [[1,2,3], [4,5,6], [7,8,9], [10,11,12]]
    q = 1
    quarters.each do |months|
      months.each { |m| expect(Time.new(2015, m).fiscal_quarter).to eq q }
      q += 1
    end

    # Adjusted fiscal calendar
    jan = Time.new(2015, 1)
    jan.fiscal_start = 4
    expect(jan.fiscal_quarter).to eq 4
    jan.fiscal_start = 10
    expect(jan.fiscal_quarter).to eq 2

    # Make sure other date classes work
    expect(Date.new(2015, 9).fiscal_quarter).to eq 3
    expect(DateTime.new(2015, 9).fiscal_quarter).to eq 3
  end

  it "#quarter_months" do
    expect(Time.method_defined? :quarter_months).to be true
    expect(Date.method_defined? :quarter_months).to be true
    expect(DateTime.method_defined? :quarter_months).to be true
  end

end
