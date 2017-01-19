class String

  def nl2br
    _nl_gsub("<br />\n")
  end

  def newline_to(rep = ' ')
    _nl_gsub(rep.to_s)
  end

  def keyify
    _prep_key_or_slug(true)
  end

  def keyify!
    result = _prep_key_or_slug(true)
    raise ArgumentError, "#{self.inspect} cannot be keyified, no valid characters" if result.nil?
    result
  end

  def slugify
    _prep_key_or_slug(false)
  end

  def slugify!
    result = _prep_key_or_slug(false)
    raise ArgumentError, "#{self.inspect} cannot be slugified, no valid characters" if result.nil?
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
    raise ArgumentError, "#{str.inspect} is not a string" unless str.is_a? String
    # Yes, this is inefficient. We welcome optimizations from the regex ninjas out there.
    ret = String.new self
    str.each_char { |c| ret.gsub! /#{Regexp.escape c}{2,}/, c }
    ret
  end

  def dedupe!(str)
    raise ArgumentError, "#{str.inspect} is not a string" unless str.is_a? String
    # Yes, this is inefficient. We welcome optimizations from the regex ninjas out there.
    str.each_char { |c| gsub! /#{Regexp.escape c}{2,}/, c }
  end

  def remove_whitespace(_ignored = nil)
    replace_whitespace('')
  end

  def remove_whitespace!(_ignored = nil)
    replace_whitespace!('')
  end

  def replace_whitespace(replace = '')
    gsub /[ ]/, replace
  end

  def replace_whitespace!(replace = '')
    gsub! /[ ]/, replace
  end

  # return true/false on regex match
  def match?(pattern, pos = 0)
    match(pattern, pos).not_nil?
  end

  # Sources:
  #   http://mentalized.net/journal/2011/04/14/ruby-how-to-check-if-a-string-is-numeric/
  #   http://rosettacode.org/wiki/Determine_if_a_string_is_numeric#Ruby
  #   http://stackoverflow.com/questions/5661466/test-if-string-is-a-number-in-ruby-on-rails/5661695
  def numeric?
    Float(self) != nil rescue false
  end

  # TODO
  def each_char_index(&block)
    # how to return enumerator if no block given?
    # http://blog.arkency.com/2014/01/ruby-to-enum-for-enumerator/
  end

  protected

    def _nl_gsub(rep)
      self.gsub(/(?:\n\r?|\r\n?)/, rep)
    end

    def _lstrip_all_regex(expr)
      /\A[#{expr}]+/
    end

    def _rstrip_all_regex(expr)
      /[#{expr}]+\Z/
    end

    def _strip_all_prep(chars)
      chars = '-_' if chars.nil?
      raise ArgumentError, "#{chars.inspect} is not a string" unless chars.is_a? String

      expr = Regexp.escape( chars.gsub(/(0-9)+|(a-z)+|(A-Z)+|\s+/, '').strip )
      ['0-9', 'a-z', 'A-Z'].each do |range|
        expr << range if chars.include? range
      end
      expr << ' '
    end

    def _prep_key_or_slug(keyified = true)
      result = nil_chain do
        the_key = self.dup

        # strip all non-alphanumerics
        the_key.gsub!(/[^0-9a-z]+/i, '_')

        # borrowing some logic from Rails method underscore
        # http://api.rubyonrails.org/classes/ActiveSupport/Inflector.html#method-i-underscore
        if the_key =~ /[A-Z-]|::/
          the_key.gsub!(/::/, '_')
          the_key.gsub!(/([A-Z\d]+)([A-Z][a-z])/,'\1_\2')
          the_key.gsub!(/([a-z\d])([A-Z])/,'\1_\2')
        end

        # Strip any leading numbers (keyify only)
        the_key.lstrip_all!('0-9') if keyified
        # Strip any leading or trailing underscores
        the_key.strip_all!('_')
        # Combine multiple concurrent underscores
        the_key.dedupe!('_')
        # lowercase
        the_key.downcase!
        # replace underscore with dashes (slugify only)
        the_key.gsub!('_', '-') unless keyified
        next the_key
      end
      case
        when result.nil? || result == ''
          nil
        when keyified
          result.to_sym
        else result
      end
    end

end
