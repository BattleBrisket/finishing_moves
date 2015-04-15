require 'spec_helper'

describe FinishingMovesFiscalLogic do

  let(:default_quarters) { [[1,2,3], [4,5,6], [7,8,9], [10,11,12]] }

  before(:example) do
    @jan01 = Time.new(2015, 1)
  end

  it "is included into Time, Date, and DateTime" do
    expect(Time.method_defined? :fiscal_start).to be true
    expect(Date.method_defined? :fiscal_start).to be true
    expect(DateTime.method_defined? :fiscal_start).to be true

    expect(Time.method_defined? :fiscal_quarter).to be true
    expect(Date.method_defined? :fiscal_quarter).to be true
    expect(DateTime.method_defined? :fiscal_quarter).to be true

    expect(Time.method_defined? :all_quarter_months).to be true
    expect(Date.method_defined? :all_quarter_months).to be true
    expect(DateTime.method_defined? :all_quarter_months).to be true

    expect(Time.method_defined? :fiscal_quarter_months).to be true
    expect(Date.method_defined? :fiscal_quarter_months).to be true
    expect(DateTime.method_defined? :fiscal_quarter_months).to be true
  end

  it "#fiscal_quarter" do
    q = 1
    default_quarters.each do |months|
      months.each { |m| expect(Time.new(2015, m).fiscal_quarter).to eq q }
      q += 1
    end

    # Adjusted fiscal calendar
    @jan01.fiscal_start = 4
    expect(@jan01.fiscal_quarter).to eq 4
    @jan01.fiscal_start = 10
    expect(@jan01.fiscal_quarter).to eq 2

    # Make sure other date classes work
    expect(Date.new(2015, 9).fiscal_quarter).to eq 3
    expect(DateTime.new(2015, 9).fiscal_quarter).to eq 3
  end

  it "#all_quarter_months" do
    expect(@jan01.all_quarter_months).to eq default_quarters
    @jan01.fiscal_start = 4
    expect(@jan01.all_quarter_months).to eq [[4,5,6], [7,8,9], [10,11,12], [1,2,3]]
    @jan01.fiscal_start = 11
    expect(@jan01.all_quarter_months).to eq [[11,12,1], [2,3,4], [5,6,7], [8,9,10]]

    expect(Date.new(2015, 9).all_quarter_months).to eq default_quarters
    expect(DateTime.new(2015, 9).all_quarter_months).to eq default_quarters
    # alias check
    expect(DateTime.new(2015, 9).fiscal_calendar).to eq default_quarters
  end

  it "#quarter shortcuts" do
    expect(@jan01.first_quarter).to eq default_quarters[0]
    expect(@jan01.q1).to eq default_quarters[0]
    expect(@jan01.second_quarter).to eq default_quarters[1]
    expect(@jan01.q2).to eq default_quarters[1]
    expect(@jan01.third_quarter).to eq default_quarters[2]
    expect(@jan01.q3).to eq default_quarters[2]
    expect(@jan01.fourth_quarter).to eq default_quarters[3]
    expect(@jan01.q4).to eq default_quarters[3]
  end

  it "#fiscal_quarter_months" do
    expect(Time.new(2015, 1).fiscal_quarter_months).to eq [1,2,3]
    expect(Date.new(2015, 2).fiscal_quarter_months).to eq [1,2,3]
    expect(DateTime.new(2015, 5).fiscal_quarter_months).to eq [4,5,6]

    @jan01.fiscal_start = 4
    expect(@jan01.fiscal_quarter_months).to eq [1,2,3]
    @jan01.fiscal_start = 2
    expect(@jan01.fiscal_quarter_months).to eq [11,12,1]
    @jan01.fiscal_start = 11
    expect(@jan01.fiscal_quarter_months).to eq [11,12,1]
    @jan01.fiscal_start = 9
    expect(@jan01.fiscal_quarter_months).to eq [12,1,2]
  end

  it "#first_month_of_quarter" do
    expect(Time.new(2015, 1).first_month_of_quarter).to eq 1
    expect(Date.new(2015, 8).first_month_of_quarter).to eq 7
    expect(DateTime.new(2015, 5).first_month_of_quarter).to eq 4

    @jan01.fiscal_start = 4
    expect(@jan01.first_month_of_quarter).to eq 1
    @jan01.fiscal_start = 2
    expect(@jan01.first_month_of_quarter).to eq 11
    @jan01.fiscal_start = 11
    expect(@jan01.first_month_of_quarter).to eq 11
    @jan01.fiscal_start = 9
    expect(@jan01.first_month_of_quarter).to eq 12
  end

  it "#beginning_of_fiscal_quarter" do
    expect(Time.new.beginning_of_fiscal_quarter).to be_a Time
    expect(Date.new.beginning_of_fiscal_quarter).to be_a Date
    expect(DateTime.new.beginning_of_fiscal_quarter).to be_a DateTime

    expect(@jan01.beginning_of_fiscal_quarter.strftime('%F')).to eq '2015-01-01'
    @jan01.fiscal_start = 4
    expect(@jan01.beginning_of_fiscal_quarter.strftime('%F')).to eq '2015-01-01'
    @jan01.fiscal_start = 2
    expect(@jan01.beginning_of_fiscal_quarter.strftime('%F')).to eq '2014-11-01'
    @jan01.fiscal_start = 11
    expect(@jan01.beginning_of_fiscal_quarter.strftime('%F')).to eq '2014-11-01'
    @jan01.fiscal_start = 9
    expect(@jan01.beginning_of_fiscal_quarter.strftime('%F')).to eq '2014-12-01'
  end

  it "#end_of_fiscal_quarter" do
    expect(Time.new.end_of_fiscal_quarter).to be_a Time
    expect(Date.new.end_of_fiscal_quarter).to be_a Date
    expect(DateTime.new.end_of_fiscal_quarter).to be_a DateTime

    expect(@jan01.end_of_fiscal_quarter.strftime('%F')).to eq '2015-03-31'
    @jan01.fiscal_start = 4
    expect(@jan01.end_of_fiscal_quarter.strftime('%F')).to eq '2015-03-31'
    @jan01.fiscal_start = 2
    expect(@jan01.end_of_fiscal_quarter.strftime('%F')).to eq '2015-01-31'
    @jan01.fiscal_start = 11
    expect(@jan01.end_of_fiscal_quarter.strftime('%F')).to eq '2015-01-31'
    @jan01.fiscal_start = 9
    expect(@jan01.end_of_fiscal_quarter.strftime('%F')).to eq '2015-02-28'

    # Separate logic for Date and DateTime means separate tests
    @jan01_date = Date.new(2015, 1)
    expect(@jan01_date.end_of_fiscal_quarter.strftime('%F')).to eq '2015-03-31'
    @jan01_date.fiscal_start = 4
    expect(@jan01_date.end_of_fiscal_quarter.strftime('%F')).to eq '2015-03-31'
    @jan01_date.fiscal_start = 2
    expect(@jan01_date.end_of_fiscal_quarter.strftime('%F')).to eq '2015-01-31'
    @jan01_date.fiscal_start = 11
    expect(@jan01_date.end_of_fiscal_quarter.strftime('%F')).to eq '2015-01-31'
    @jan01_date.fiscal_start = 9
    expect(@jan01_date.end_of_fiscal_quarter.strftime('%F')).to eq '2015-02-28'

    @jan01_datetime = DateTime.new(2015, 1)
    expect(@jan01_datetime.end_of_fiscal_quarter.strftime('%F')).to eq '2015-03-31'
    @jan01_datetime.fiscal_start = 4
    expect(@jan01_datetime.end_of_fiscal_quarter.strftime('%F')).to eq '2015-03-31'
    @jan01_datetime.fiscal_start = 2
    expect(@jan01_datetime.end_of_fiscal_quarter.strftime('%F')).to eq '2015-01-31'
    @jan01_datetime.fiscal_start = 11
    expect(@jan01_datetime.end_of_fiscal_quarter.strftime('%F')).to eq '2015-01-31'
    @jan01_datetime.fiscal_start = 9
    expect(@jan01_datetime.end_of_fiscal_quarter.strftime('%F')).to eq '2015-02-28'
  end

  it "#beginning_of_fiscal_year" do
    expect(Time.new.beginning_of_fiscal_year).to be_a Time
    expect(Date.new.beginning_of_fiscal_year).to be_a Date
    expect(DateTime.new.beginning_of_fiscal_year).to be_a DateTime

    @jan01.fiscal_start = 3
    expect(@jan01.beginning_of_fiscal_year.strftime('%F')).to eq '2014-03-01'
    @jan01.fiscal_start = 9
    expect(@jan01.beginning_of_fiscal_year.strftime('%F')).to eq '2014-09-01'
    @jan01.fiscal_start = 12
    expect(@jan01.beginning_of_fiscal_year.strftime('%F')).to eq '2014-12-01'
  end

  it "#end_of_fiscal_year" do
    expect(Time.new.end_of_fiscal_year).to be_a Time
    expect(Date.new.end_of_fiscal_year).to be_a Date
    expect(DateTime.new.end_of_fiscal_year).to be_a DateTime

    @jan01.fiscal_start = 3
    expect(@jan01.end_of_fiscal_year.strftime('%F')).to eq '2015-02-28'
    @jan01.fiscal_start = 9
    expect(@jan01.end_of_fiscal_year.strftime('%F')).to eq '2015-08-31'
    @jan01.fiscal_start = 12
    expect(@jan01.end_of_fiscal_year.strftime('%F')).to eq '2015-11-30'

    # Separate logic for Date and DateTime means separate tests
    @jan01_date = Date.new(2015, 1)
    @jan01_date.fiscal_start = 3
    expect(@jan01_date.end_of_fiscal_year.strftime('%F')).to eq '2015-02-28'
    @jan01_date.fiscal_start = 9
    expect(@jan01_date.end_of_fiscal_year.strftime('%F')).to eq '2015-08-31'
    @jan01_date.fiscal_start = 12
    expect(@jan01_date.end_of_fiscal_year.strftime('%F')).to eq '2015-11-30'

    @jan01_datetime = DateTime.new(2015, 1)
    @jan01_datetime.fiscal_start = 3
    expect(@jan01_datetime.end_of_fiscal_year.strftime('%F')).to eq '2015-02-28'
    @jan01_datetime.fiscal_start = 9
    expect(@jan01_datetime.end_of_fiscal_year.strftime('%F')).to eq '2015-08-31'
    @jan01_datetime.fiscal_start = 12
    expect(@jan01_datetime.end_of_fiscal_year.strftime('%F')).to eq '2015-11-30'
  end

  it "#quarter_starting_dates" do
    expect(@jan01.quarter_starting_dates).to be_an Array
    expect(@jan01.quarter_starting_dates.length).to eq 4

    expect(@jan01.quarter_starting_dates[0].strftime('%F')).to eq '2015-01-01'
    expect(@jan01.quarter_starting_dates[1].strftime('%F')).to eq '2015-04-01'
    expect(@jan01.quarter_starting_dates[2].strftime('%F')).to eq '2015-07-01'
    expect(@jan01.quarter_starting_dates[3].strftime('%F')).to eq '2015-10-01'

    @jan01.fiscal_start = 2
    expect(@jan01.quarter_starting_dates[0].strftime('%F')).to eq '2014-02-01'
    expect(@jan01.quarter_starting_dates[1].strftime('%F')).to eq '2014-05-01'
    expect(@jan01.quarter_starting_dates[2].strftime('%F')).to eq '2014-08-01'
    expect(@jan01.quarter_starting_dates[3].strftime('%F')).to eq '2014-11-01'

    @jan01.fiscal_start = 9
    expect(@jan01.quarter_starting_dates[0].strftime('%F')).to eq '2014-09-01'
    expect(@jan01.quarter_starting_dates[1].strftime('%F')).to eq '2014-12-01'
    expect(@jan01.quarter_starting_dates[2].strftime('%F')).to eq '2015-03-01'
    expect(@jan01.quarter_starting_dates[3].strftime('%F')).to eq '2015-06-01'

    @jan01_date = Date.new(2015, 1)
    expect(@jan01_date.quarter_starting_dates[0].strftime('%F')).to eq '2015-01-01'
    expect(@jan01_date.quarter_starting_dates[1].strftime('%F')).to eq '2015-04-01'
    expect(@jan01_date.quarter_starting_dates[2].strftime('%F')).to eq '2015-07-01'
    expect(@jan01_date.quarter_starting_dates[3].strftime('%F')).to eq '2015-10-01'
  end

  it "#quarter_ending_dates" do
    expect(@jan01.quarter_ending_dates).to be_an Array
    expect(@jan01.quarter_ending_dates.length).to eq 4

    expect(@jan01.quarter_ending_dates[0].strftime('%F')).to eq '2015-03-31'
    expect(@jan01.quarter_ending_dates[1].strftime('%F')).to eq '2015-06-30'
    expect(@jan01.quarter_ending_dates[2].strftime('%F')).to eq '2015-09-30'
    expect(@jan01.quarter_ending_dates[3].strftime('%F')).to eq '2015-12-31'

    @jan01.fiscal_start = 2
    expect(@jan01.quarter_ending_dates[0].strftime('%F')).to eq '2014-04-30'
    expect(@jan01.quarter_ending_dates[1].strftime('%F')).to eq '2014-07-31'
    expect(@jan01.quarter_ending_dates[2].strftime('%F')).to eq '2014-10-31'
    expect(@jan01.quarter_ending_dates[3].strftime('%F')).to eq '2015-01-31'

    @jan01.fiscal_start = 9
    expect(@jan01.quarter_ending_dates[0].strftime('%F')).to eq '2014-11-30'
    expect(@jan01.quarter_ending_dates[1].strftime('%F')).to eq '2015-02-28'
    expect(@jan01.quarter_ending_dates[2].strftime('%F')).to eq '2015-05-31'
    expect(@jan01.quarter_ending_dates[3].strftime('%F')).to eq '2015-08-31'

    @jan01_date = Date.new(2015, 1)
    expect(@jan01_date.quarter_ending_dates[0].strftime('%F')).to eq '2015-03-31'
    expect(@jan01_date.quarter_ending_dates[1].strftime('%F')).to eq '2015-06-30'
    expect(@jan01_date.quarter_ending_dates[2].strftime('%F')).to eq '2015-09-30'
    expect(@jan01_date.quarter_ending_dates[3].strftime('%F')).to eq '2015-12-31'
  end

end
