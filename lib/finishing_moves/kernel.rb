module Kernel

  def nil_chain(ret_val = nil, &block)
    begin
      result = yield
      return ret_val if result.nil?
      result
    rescue NoMethodError, NameError
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

  def cascade(&block)
    loop do
      yield
      break
    end
  end

  def silently(ret_val = nil, &block)
    begin
      result = yield
      return ret_val if result.nil?
      result
    rescue
      return ret_val
    end
  end

end
