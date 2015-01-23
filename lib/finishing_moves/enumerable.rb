module Enumerable

  def key_map(key)
    map { |h| h[key] }
  end

  def key_map_reduce(key, arg = :+, &block)
    if block_given?
      # arg is the initial value of memo
      key_map(key).reduce(arg, &block)
    else
      # arg is a named method
      raise ArgumentError.new "arg must be a method symbol" unless arg.is_a? Symbol
      key_map(key).reduce(arg)
    end
  end

end
