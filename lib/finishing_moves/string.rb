class String

  def nl2br
    self.gsub(/(?:\n\r?|\r\n?)/, "<br />\n")
  end

  def keyify
    result = nil_chain do
      the_key = self

      # strip all non-alphanumerics
      the_key.gsub!(/[^0-9a-z]+/i, '_')

      # borrowing some logic from Rails method underscore
      # http://api.rubyonrails.org/classes/ActiveSupport/Inflector.html#method-i-underscore
      if the_key =~ /[A-Z-]|::/
        the_key.gsub!(/::/, '_')
        the_key.gsub!(/([A-Z\d]+)([A-Z][a-z])/,'\1_\2')
        the_key.gsub!(/([a-z\d])([A-Z])/,'\1_\2')
      end

      # Strip any leading numbers and underscores
      the_key.lstrip_all!('0-9_')
      # Strip trailing underscores
      the_key.rstrip_all!('_')
      # Combine multiple concurrent underscores
      the_key.dedupe!('_')
      # lowercase
      the_key.downcase!
      next the_key
    end
    return nil if result.nil? || result == ''
    result.to_sym
  end

  def keyify!
    result = self.keyify
    raise ArgumentError, '#{self.inspect} cannot be keyified, no valid characters' if result.nil?
    result
  end

  def strip_all(chars = nil)
    expr = _strip_all_prep(chars)
    gsub Regexp.union(_lstrip_all_regex(expr), _rstrip_all_regex(expr)), ''
  end

  def strip_all!(chars = nil)
    expr = _strip_all_prep(chars)
    gsub! Regexp.union(_lstrip_all_regex(expr), _rstrip_all_regex(expr)), ''
  end

  def lstrip_all(chars = nil)
    gsub _lstrip_all_regex(_strip_all_prep(chars)), ''
  end

  def lstrip_all!(chars = nil)
    gsub! _lstrip_all_regex(_strip_all_prep(chars)), ''
  end

  def rstrip_all(chars = nil)
    gsub _rstrip_all_regex(_strip_all_prep(chars)), ''
  end

  def rstrip_all!(chars = nil)
    gsub! _rstrip_all_regex(_strip_all_prep(chars)), ''
  end

  # strip multiple concurrent characters
  def dedupe(str)
    raise ArgumentError, '#{str.inspect} is not a string' unless str.is_a? String
    # Yes, this is inefficient. We welcome optimizations from the regex ninjas out there.
    ret = self
    str.each_char { |c| ret.gsub! /#{Regexp.escape c}{2,}/, c }
    ret
  end

  def dedupe!(str)
    raise ArgumentError, '#{str.inspect} is not a string' unless str.is_a? String
    str.each_char { |c| gsub! /#{Regexp.escape c}{2,}/, c }
  end

  def remove_whitespace
  end

  def replace_whitespace(replace = '')
  end

  # return true/false on regex match
  def match?(pattern, pos = 0)
    match(pattern, pos).not_nil?
  end

  protected

    def _lstrip_all_regex(expr)
      /\A[#{expr}]+/
    end

    def _rstrip_all_regex(expr)
      /[#{expr}]+\Z/
    end

    def _strip_all_prep(chars)
      chars = '-_' if chars.nil?
      raise ArgumentError, '#{chars.inspect} is not a string' unless chars.is_a? String

      expr = Regexp.escape( chars.gsub(/(0-9)+|(a-z)+|(A-Z)+|\s+/, '').strip )
      ['0-9', 'a-z', 'A-Z'].each do |range|
        expr << range if chars.include? range
      end
      expr << ' '
    end

end

# default to dashes and underscores
# strip_all("0-9_", ".rb")

class Symbol

  def keyify
    to_s.keyify
  end

end
