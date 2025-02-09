class Hash

  # When deleting a value from a hash, return the remaining hash, instead of the deleted value
  def delete!(key)
    self.delete(key)
    return self
  end

  # Delete all records according to the keys passed in as an array, and return a hash of deleted
  # entries. Silently ignores any keys which are not found.
  def delete_each(*hash_keys)
    deleted_entries = {}
    hash_keys.each do |hash_key|
      value = self.delete(hash_key)
      deleted_entries[hash_key] = value unless value.nil?
    end
    return deleted_entries unless deleted_entries.empty?
    nil
  end

  # Delete all records according to the keys passed in as array, and return the remaining hash.
  def delete_each!(*keys)
    self.delete_each(*keys)
    return self
  end

  def sample
    key = self.keys.sample
    return {:"#{key}" => self[key]}
  end

  # TODO
  # Replicate `sample` method functionality from Array
  # def sample(count)
  #   key = self.keys.sample
  #   return {:"#{key}" => self[key]}
  # end

  # TODO
  # sort in place using default `hash.sort` logic
  # def sort!
  #   self = self.sort
  #   return self
  # end

end
