class Symbol

  # TODO
  # Credit: http://thingsinabucket.com/2015/07/01/three_little_hacks/
  def ~@
    -> (o) { o.respond_to?(self) }
  end

  def keyify
    to_s.keyify
  end

  def slugify
    to_s.slugify
  end

  def keyify!
    to_s.keyify!
  end

  def slugify!
    to_s.slugify!
  end

end
