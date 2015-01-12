# http://www.channaly.info/nl2br-strtr-php-functions-in-ruby/

class String

  def nl2br
    self.gsub("\n", "<br />\n")
  end

  def keyify
    # Throw error if string doesn't contain a letter
    # lowercase
    # replace non-alpha numerics /^[a-z0-9]/ with underscore
    # Strip leading number(s)
    # Strip leading underscore(s)
    # combine multiple concurrent underscores
    # make symbol
  end

end
