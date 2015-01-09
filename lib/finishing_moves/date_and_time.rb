module FinishingMovesFiscalLogic

  def fiscal_quarter
    ((self.month - 1) / 3) + 1
  end

  # return array of month integers correspond to appropriate quarter interger
  def quarter_months
    quarters = [[1,2,3], [4,5,6], [7,8,9], [10,11,12]]
    quarters[self.month - 1]
  end

end

class Time
  include FinishingMovesFiscalLogic
end

class Date
  include FinishingMovesFiscalLogic
end

class DateTime
  include FinishingMovesFiscalLogic
end


# also what a reverse_map method?
# https://www.ruby-forum.com/topic/110660
# http://www.ruby-doc.org/core-2.2.0/Array.html#method-i-reverse_each
# http://stackoverflow.com/questions/2070574/is-there-a-reason-that-we-cannot-iterate-on-reverse-range-in-ruby#2070587
#

# sorting a hash in place by key
# http://www.rubyinside.com/how-to/ruby-sort-hash
# http://www.informit.com/articles/article.aspx?p=1244471&seqNum=9
# http://stackoverflow.com/questions/2540435/how-to-sort-a-ruby-hash-by-number-value
