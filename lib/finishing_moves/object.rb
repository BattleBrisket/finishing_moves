class Object
  def not_nil?
    !self.nil?
  end

  def same_as(compare)
    if compare.respond_to? :to_s
      self.to_s == compare.to_s
    else
      raise ArgumentError.new("Cannot compare \"#{self.class.name}\" to \"#{compare.class.name}\", no string conversion")
    end
  end
  def self.keyify
    self.class.name.to_s.keyify
  end

end
