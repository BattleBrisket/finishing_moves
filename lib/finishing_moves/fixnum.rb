class Numeric
  def length
    raise ArgumentError.new("Cannot get length: \"#{self}\" is not an integer")
  end
  alias_method :digits, :length

  def subtract_percent(percent)
    self.to_f * ((100.0 - percent.to_f)/100.0)
  end
  alias_method :percentage_off, :subtract_percent
end

class Integer
  def length
    Math.log10(self.abs).to_i + 1
  end
  alias_method :digits, :length
end
