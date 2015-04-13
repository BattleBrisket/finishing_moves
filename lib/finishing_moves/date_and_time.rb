module FinishingMovesFiscalLogic

  def fiscal_start
    @fiscal_start = 1 if @fiscal_start.nil?
    @fiscal_start
  end

  def fiscal_start=(month)
    @fiscal_start = Integer(month)
  end

  def fiscal_quarter
    (((self.month + (12 - fiscal_start) ) / 3) % 4) + 1
  end

  # return array of month integers correspond to appropriate quarter interger
  def quarter_months
  end

end

class Time
  include FinishingMovesFiscalLogic
end

class Date
  include FinishingMovesFiscalLogic
end

class DateTime
  include FinishingMovesFiscalLogic
end
