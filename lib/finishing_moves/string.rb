# http://www.channaly.info/nl2br-strtr-php-functions-in-ruby/

class String

  def nl2br
    self.gsub(/(?:\n\r?|\r\n?)/, "<br />\n")
  end

  def keyify
    retval = nil_chain do
      str = self
      # replace non-alpha numerics with underscore
      str = str.gsub(/[^0-9a-z]/i, '_')
      # Strip leading numbers and underscores
      str = str.gsub(/^[0-9_]+/, '')
      # Strip trailing underscores
      str = str.gsub(/_+$/, '')
      # Combine multiple concurrent underscores
      str = str.gsub(/_{2,}/, '_')
      # lowercase and make symbol
      str.downcase.to_sym
    end
    return "" if retval.nil?
    retval
  end

  # strip leading and trailing characters
  def unwrap(chars, options = {})
    whitespace = options[:whitespace] || true
    regex = options[:regex] || false

    if regex
      expr = chars.to_s
    else
      escapes = '. $ ^ { [ ( | ) ] } * + ? \ '
      expr = ''
      chars.to_s.gsub(/\s+/, '').strip.each_char do |c|
        expr << "\\" if escapes.include? c
        expr << c
      end
      expr = expr + ' ' if whitespace
    end

    self.gsub(/^[#{expr}]+/i, '').gsub(/[#{expr}]+$/i, '')
  end

  # strip multiple concurrent characters
  # remove all whitespace
  # replace all whitespace
  # return true/false on regex match

  # catch methods in NilClass, return empty string
end
