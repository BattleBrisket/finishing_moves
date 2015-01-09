# http://www.channaly.info/nl2br-strtr-php-functions-in-ruby/

class String

  def nl2br
    self.gsub("\n", "<br />\n")
  end

  def keyify
    lowercase
    replace spaces with underscore
    remove non-alphas
    ensure starts with letter
    make symbol
  end

  def pathify
  end

  def depathify
  end

  # http://stackoverflow.com/questions/3574028/how-do-i-convert-a-string-text-into-a-class-name
  # # Attempt to convert a string (usually from params) into an ActiveRecord model name
  # def depathify(str)
  #   str.tr('-', '_').classify
  # end

end
