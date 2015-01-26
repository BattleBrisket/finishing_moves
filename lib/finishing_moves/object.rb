class Object

  def not_nil?
    !self.nil?
  end

  alias_method :is_an?, :is_a?

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

end
