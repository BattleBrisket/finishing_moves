class Integer
  def length
    Math.log10(self.abs).to_i + 1
  end
  alias_method :digits, :length
  
  def percentage_off(percent)
    self * ((100.0 - percent.to_f)/100.0)
  end
end

class Float
  def length
    raise ArgumentError.new("Cannot get length: \"#{self}\" is not an integer")
  end
  alias_method :digits, :length
  
  def percentage_off(percent)
    self * ((100.0 - percent.to_f)/100.0)
  end
end

class BigDecimal
  def length
    raise ArgumentError.new("Cannot get length: \"#{self}\" is not an integer")
  end
  alias_method :digits, :length
  
  def percentage_off(percent)
    self * ((100.0 - percent.to_f)/100.0)
  end
end
