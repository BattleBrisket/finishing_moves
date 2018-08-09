class Array

  def to_hash_values(starting_key = 0, &block)
    key = starting_key
    block = proc { |key| key + 1 } unless block_given?
    t = {}
    each do |entry|
      t[key] = entry
      key = block.call key
    end
    t
  end
  alias_method :to_hash_as_values, :to_hash_values

  def to_indexed_hash(starting_key = 0)
    raise ArgumentError, "#{starting_key.inspect} is not an integer" unless starting_key.is_a? Integer
    to_hash_values(starting_key)
  end

  def to_hash_keys(starting_value = 0, &block)
    t = {}
    block = proc { starting_value } unless block_given?
    each do |entry|
      t[entry] = block.call entry
    end
    t
  end
  alias_method :to_hash_as_keys, :to_hash_keys

  def to_sym
    map { |x| x.to_sym }
  end
  alias_method :to_sym_hard, :to_sym

  def to_sym!
    map! { |x| x.to_sym }
  end
  alias_method :to_sym_hard!, :to_sym!

  def to_sym_soft
    map do |x|
      begin
        x.to_sym
      rescue NoMethodError => e
        x
      rescue Exception
        raise
      end
    end
  end

  def to_sym_soft!
    map! do |x|
      begin
        x.to_sym
      rescue NoMethodError => e
        x
      rescue Exception
        raise
      end
    end
  end

end
