require 'date'

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

  def fiscal_quarter_months
    all_quarter_months[fiscal_quarter - 1]
  end

  def first_month_of_quarter
    fiscal_quarter_months[0]
  end

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
    self.class.new _last_fiscal_year_for_month(q1[0]), q1[0]
  end

  def beginning_of_fiscal_quarter
    self.class.new _last_fiscal_year_for_month(first_month_of_quarter), first_month_of_quarter
  end

  def end_of_fiscal_year
    if self.class.name == 'Time'
      d = beginning_of_fiscal_year + (60*60*24*385)
      self.class.new(d.year, d.month) - (60*60*24)
    else
      d = beginning_of_fiscal_year >> 12
      self.class.new(d.year, d.month) - 1
    end
  end

  def end_of_fiscal_quarter
    if self.class.name == 'Time'
      d = beginning_of_fiscal_quarter + (60*60*24*100)
      self.class.new(d.year, d.month) - (60*60*24)
    else
      d = beginning_of_fiscal_quarter >> 3
      self.class.new(d.year, d.month) - 1
    end
  end

  def quarter_starting_dates
    ret = []
    all_quarter_months.map { |months| months[0] }.each do |m|
      y = m >= fiscal_start ? starting_year : starting_year + 1
      ret << self.class.new(y, m)
    end
    ret
  end

  def quarter_ending_dates
    ret = []
    all_quarter_months.map { |months| months[2] }.each do |m|
      y = m >= fiscal_start ? starting_year : starting_year + 1
      if self.class.name == 'Time'
        d = self.class.new(y, m) + (60*60*24*42)
        ret << self.class.new(d.year, d.month) - (60*60*24)
      else
        d = self.class.new(y, m) >> 1
        ret << self.class.new(d.year, d.month) - 1
      end
    end
    ret
  end

  protected

  def starting_year
    fiscal_start > 1 ? self.year - 1 : self.year
  end

  def _last_fiscal_year_for_month(month)
    if month == fiscal_start && month == self.month
      self.year
    else
      month >= fiscal_start ? self.year - 1 : self.year
    end
  end

end

Time.send :include, FinishingMovesFiscalLogic
Date.send :include, FinishingMovesFiscalLogic
DateTime.send :include, FinishingMovesFiscalLogic
