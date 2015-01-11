class Integer
  def length
    Math.log10(self.abs).to_i + 1
  end
  alias_method :digits, :length
end

class Float
  def length
    raise ArgumentError.new("Cannot get length: \"#{self}\" is not an integer")
  end
  alias_method :digits, :length
end

class BigDecimal
  def length
    raise ArgumentError.new("Cannot get length: \"#{self}\" is not an integer")
  end
  alias_method :digits, :length
end
