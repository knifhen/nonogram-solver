class Field
  attr_accessor :minStart, :minEnd, :maxStart, :maxEnd, :start, :end, :length

  def isComplete
    return minStart == maxStart && minEnd == maxEnd
  end

  def maxStartOverlapMinEnd
    return maxStart <= minEnd
  end

  def canExistBefore index, row
    maxFree = 0
    free = 0
    if index < minEnd
      return false
    end
    (minStart..index).each { |i|
      value = row[i]
      if value != 0
        free += 1
      else
        maxFree = [maxFree, free].max
        free = 0
      end
    }
    maxFree = [maxFree, free].max
    return maxFree >= length
  end

  def canExistAfter index, row
    if index > maxStart
      return false
    end
    maxFree = 0
    free = 0
    (index..maxEnd).each { |i|
      value = row[i]
      if value != 0
        free += 1
      else
        maxFree = [maxFree, free].max
        free = 0
      end
    }
    maxFree = [maxFree, free].max
    return maxFree >= length
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
