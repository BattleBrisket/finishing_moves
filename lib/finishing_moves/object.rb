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
    self.to_s == compare.to_s
  end
  alias_method :same_as?, :same_as

  # Allows us to call keyify directly on a class name.
  # See keyify() in string.rb for details.
  def self.keyify
    name.keyify
  end

  def self.keyify!
    name.keyify!
  end

  def self.slugify
    name.slugify
  end

  def self.slugify!
    name.slugify!
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

  def false_?
    raise "value is not a boolean class (#{self.class.name})" if !bool?
    false?
  end

  def true_?
    raise "value is not a boolean class (#{self.class.name})" if !bool?
    true?
  end

  def is_one_of?( *klasses )
    klasses.each do |klass|
      return true if is_a? klass
    end
    return false
  end

  # Sources:
  #   http://mentalized.net/journal/2011/04/14/ruby-how-to-check-if-a-string-is-numeric/
  #   http://rosettacode.org/wiki/Determine_if_a_string_is_numeric#Ruby
  #   http://stackoverflow.com/questions/5661466/test-if-string-is-a-number-in-ruby-on-rails/5661695
  def numeric?
    Float(self) != nil rescue false
  end

end
