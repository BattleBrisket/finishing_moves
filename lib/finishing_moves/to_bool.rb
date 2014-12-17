class String
  def to_bool
    return true if self == true || self =~ (/^(1|t(rue)?|y(es)?|on)$/i)
    return false if self == false || self == "" || self =~ /\A[[:space:]]*\z/ || self =~ (/^(0|f(alse)?|no?|off)$/i)
    raise ArgumentError.new("invalid value for Boolean: \"#{self}\"")
  end
end

class Fixnum
  def to_bool
    return true if self == 1
    return false if self == 0
    raise ArgumentError.new("invalid value for Boolean: \"#{self}\"")
  end
end

class TrueClass
  def to_bool; self; end
  def to_i; 1; end
  def to_sym; :true; end
end

class FalseClass
  def to_bool; self; end
  def to_i; 0; end
  def to_sym; :false; end
end

class NilClass
  def to_bool; false; end
  def to_i; 0; end
  def to_sym; :nil; end
end
