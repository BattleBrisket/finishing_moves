class Array
  def to_hash_as_values(starting_key = 0, &block)
    key = starting_key
    block = proc { |key| key + 1 } unless block_given?
    t = {}
    each do |entry|
      t[key] = entry
      key = block.call key
    end
    t
  end
  alias_method :use_as_values_for_hash, :to_hash_as_values 
  alias_method :use_as_values, :to_hash_as_values

  # original fill_hash method (which was inefficient there is at least 2 iterations. (Does hash also check if each new key exists? If so then 3...))
  # Did not agree with the name
  # also map is a instance method
  # do not need to prefix self when using map
  def to_indexed_hash(starting_key = 0)
    raise ArgumentError, '#{starting_key.inspect} is not an integer' unless starting_key.is_a? Integer
    to_hash_as_values(starting_key) { |i| i + 1 }
  end

  # original fill_hash_keys method (inefficient as stated above)
  # also did not agree with the name
  # default value should usually be nil.
  def to_hash_as_keys(default_value = nil, &block)
    t = {}
    block = proc { default_value } unless block_given?
    each do |entry|
      t[entry] = block.call entry
    end
    t
  end
  alias_method :use_as_keys_for_hash, :to_hash_as_keys
  alias_method :use_as_keys, :to_hash_as_keys

end
