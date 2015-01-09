class Array

  def fill_hash(starting_key = 0)
    key = starting_key
    Hash[self.map do |value|
      add = [key, value]
      key += 1
      next add
    end]
  end

  def fill_hash_keys(default_value = 0)
    Hash[self.map { |key| [key, default_value] } ]
  end

end
