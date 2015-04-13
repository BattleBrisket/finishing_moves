module FinishingMovesFiscalLogic

  def fiscal_start
    @fiscal_start = 1 if @fiscal_start.nil?
    @fiscal_start
  end

  def fiscal_start=(month)
    @fiscal_start = Integer(month)
  end

  def fiscal_quarter
    ((( self.month + ( 12 - fiscal_start ) ) / 3 ) % 4 ) + 1
  end

  def all_quarter_months
    quarters = []
    this_quarter = []
    this_month = fiscal_start
    (1..12).each do |n|
      this_quarter << this_month
      if n % 3 == 0
        quarters << this_quarter
        this_quarter = []
      end
      this_month = this_month < 12 ? this_month + 1 : 1
    end
    quarters
  end
  alias_method :fiscal_calendar, :all_quarter_months

  def first_quarter
    all_quarter_months[0]
  end
  alias_method :q1, :first_quarter

  def second_quarter
    all_quarter_months[1]
  end
  alias_method :q2, :second_quarter

  def third_quarter
    all_quarter_months[2]
  end
  alias_method :q3, :third_quarter

  def fourth_quarter
    all_quarter_months[3]
  end
  alias_method :q4, :fourth_quarter

  def beginning_of_fiscal_year
    self.class.new self.year, first_quarter[0]
  end

  def end_of_fiscal_year
    if self.class.name == 'Time'
      d = beginning_of_fiscal_year + (60*60*24*385)
    else
      d = beginning_of_fiscal_year >> 13
    end
    self.class.new(d.year, d.month) - 1
  end

  def quarter_months
    all_quarter_months[fiscal_quarter - 1]
  end

  def first_month_of_quarter
    quarter_months[0]
  end

  def beginning_of_fiscal_quarter
    self.class.new self.year, first_month_of_quarter
  end

  def quarter_starts
    [
      self.class.new(self.year, first_quarter[0]),
      self.class.new(self.year, second_quarter[0]),
      self.class.new(self.year, third_quarter[0]),
      self.class.new(self.year, fourth_quarter[0]),
    ]
  end

end

Time.send :include, FinishingMovesFiscalLogic

require 'date'
Date.send :include, FinishingMovesFiscalLogic
DateTime.send :include, FinishingMovesFiscalLogic
