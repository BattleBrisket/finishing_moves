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

  # What about a reverse_map method?
  # https://www.ruby-forum.com/topic/110660
  # http://www.ruby-doc.org/core-2.2.0/Array.html#method-i-reverse_each
  # http://stackoverflow.com/questions/2070574/is-there-a-reason-that-we-cannot-iterate-on-reverse-range-in-ruby#2070587

end
