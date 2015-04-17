class Numeric
  def length
    raise ArgumentError.new("Cannot get length: \"#{self}\" is not an integer")
  end
  alias_method :digits, :length

  def subtract_percent(percent)
    self.to_f * ( ( 100.0 - percent.to_f ) / 100.0 )
  end
  alias_method :percentage_off, :subtract_percent

  def add_percent(percent)
    self.to_f + ( self.to_f * ( percent.to_f / 100.0 ) )
  end
  alias_method :markup_by_percent, :add_percent
end

class Integer
  def length
    Math.log10(self.abs).to_i + 1
  end
  alias_method :digits, :length
end
