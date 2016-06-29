class Object

  def not_nil?
    !self.nil?
  end

  alias_method :is_an?, :is_a?

  def is_not_a?(compare)
    !is_a? compare
  end
  alias_method :is_not_an?, :is_not_a?

  def same_as(compare)
    if compare.respond_to? :to_s
      self.to_s == compare.to_s
    else
      raise ArgumentError.new("Cannot compare \"#{self.class.name}\" to \"#{compare.class.name}\", no string conversion")
    end
  end
  alias_method :same_as?, :same_as

  # Allows us to call keyify directly on a class name.
  # See keyify() in string.rb for details.
  def self.keyify
    name.keyify
  end

  def self.slugify
    name.slugify
  end

  def false?
    return true if self.is_a? FalseClass
    return false
  end

  def true?
    return true if self.is_a? TrueClass
    return false
  end

  def bool?
    return true if self.is_one_of? TrueClass, FalseClass
    return false
  end

  def is_one_of?( *klasses )
    klasses.each do |klass|
      return true if is_a? klass
    end
    return false
  end

end
