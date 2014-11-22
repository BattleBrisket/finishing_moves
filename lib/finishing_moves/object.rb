class Object

  def nil_chain(&block)
    begin
      yield
    rescue NoMethodError
    rescue NameError
      return nil
    end
  end
  alias_method :chain, :nil_chain

  def bool_chain(&block)
    result = nil_chain{ yield }
    return false if result.nil?
    result
  end

  def class_exists?(class_name)
    klass = Module.const_get(class_name.to_s)
    return klass.is_a?(Class)
  rescue NameError
    return false
  end

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


end
