module FinishingMovesFiscalLogic

  def fiscal_quarter
    ((self.month - 1) / 3) + 1
  end

  # return array of month integers correspond to appropriate quarter interger
  def quarter_months
    quarters = [[1,2,3], [4,5,6], [7,8,9], [10,11,12]]
    quarters[self.month - 1]
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
