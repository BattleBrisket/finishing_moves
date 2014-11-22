class Fixnum
  def length
    Math.log10(self.abs).to_i + 1
  end
end

class Bignum
  def length
    Math.log10(self.abs).to_i + 1
  end
end

class Float
  def length
    raise ArgumentError.new("Cannot get length: \"#{self}\" is not an integer")
  end
end

class BigDecimal
  def length
    raise ArgumentError.new("Cannot get length: \"#{self}\" is not an integer")
  end
end
