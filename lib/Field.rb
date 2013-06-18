class Field
  attr_accessor :minStart, :minEnd, :maxStart, :maxEnd, :start, :end, :length

  def isComplete
    return minStart == maxStart && minEnd == maxEnd
  end

  def maxStartOverlapMinEnd
    return maxStart <= minEnd
  end

  def updateMinStart
    @minStart = minEnd - length + 1
  end

  def updateMinEnd
    @minEnd = minStart + length - 1
  end

  def updateMaxStart
    @maxStart = maxEnd - length + 1
  end

  def updateMaxEnd
    @maxEnd = maxStart + length - 1
  end

  def updateLength
    @length = @end - start + 1
  end

end
