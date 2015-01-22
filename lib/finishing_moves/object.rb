class Object

  def nil_chain(ret_val = nil, &block)
    begin
      result = yield
      return ret_val if result.nil?
      result
    rescue NoMethodError
    rescue NameError
      return ret_val
    end
  end
  alias_method :method_chain, :nil_chain

  def bool_chain(&block)
    result = nil_chain(&block)
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

  def cascade(&block)
    loop do
      yield
      break
    end
  end

  def self.keyify
    self.class.name.to_s.keyify
  end

end
