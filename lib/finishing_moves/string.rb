class String

  def nl2br
    self.gsub(/(?:\n\r?|\r\n?)/, "<br />\n")
  end

  def keyify
    retval = nil_chain('') do
      # replace non-alpha numerics with underscore
      gsub(/[^0-9a-z]/i, '_').
      # Strip leading numbers and underscores
      lstrip_all('0-9_').
      # Strip trailing underscores
      rstrip_all.
      # Combine multiple concurrent underscores
      dedupe('_').
      # lowercase and make symbol
      downcase.to_sym
    end
    raise ArgumentError, '#{self.inspect} cannot be keyified, no valid characters' if retval == ''
    retval
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
    gsub(/(#{Regexp.escape str}){2,}/, str)
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
      ['0-9', 'a-z', 'A-Z'].each { |range| expr << range if chars.include? range }
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
