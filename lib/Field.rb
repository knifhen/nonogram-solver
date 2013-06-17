class Field
  attr_accessor :minStart, :minEnd, :maxStart, :maxEnd, :start, :end, :length

  def maxStartOverlapMinEnd
    return maxStart <= minEnd
  end

  def updateMinEnd
      @minEnd = minStart + length - 1
  end

  def updateMaxStart
      @maxStart = maxEnd - length + 1
  end

end
