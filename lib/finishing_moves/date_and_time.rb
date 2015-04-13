module FinishingMovesFiscalLogic

  attr_reader :fiscal_start
  attr_reader :quarters

  def self.included(base) # built-in Ruby hook for modules
    base.class_eval do
      original_method = instance_method(:initialize)
      define_method(:initialize) do |*args, &block|
        original_method.bind(self).call(*args, &block)
        @fiscal_start = 1
      end
    end
  end

  def fiscal_start=(month)
    @fiscal_start = Integer(month)
  end

  def fiscal_quarter
    (((self.month + (12 - @fiscal_start) ) / 3) % 4) + 1
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
