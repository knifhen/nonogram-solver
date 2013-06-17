require 'Field'

class NonogramSolver
  def main
    clearScreen

    encodedImage = [[[2],[4],[4],[2]], [[2],[4],[4],[2]]]
    #encodedImage = [[[1,1],[0],[0],[1,1]], [[1,1],[0],[0],[1,1]]]

    image = solve encodedImage

    #image = [[0,1,1,0], [1,1,1,1], [1,1,1,1], [0,1,1,0]]
    printImage image
  end

  def solve encodedImage
    image = initImage encodedImage
    image = decodeImage encodedImage, image
    return image
  end

  def clearScreen
    puts "\e[H\e[2J"
  end

  def printImage image
    image.each { |row|
      row.each { |pixel|
        print pixel
      }
      puts ""
    }
  end

  def initImage encodedImage
    image = []
    width = encodedImage[0].length
    height = encodedImage[1].length
    height.times {
      row = []
      width.times {
        row << -1
      }
      image << row
    }
    return image
  end

  def getColumn image, x
    column = []
    image.each { |row|
      column << row[x]
    }
    return column
  end

  def insertColumn image, column, x
    column.each_with_index { |pixel, i|
      image[i][x] = pixel
    }
    return image
  end


  def decodeRow row, encodedRow
    fields = initMinIndex encodedRow
    fields = initMaxIndex row, fields, encodedRow
    row = updateRowWithOverlappingFields row, fields
    row = updateRowWithNotOverlappingFields row, fields
    row = updateRowWithAllFieldsComplete row, fields
    row = updateRowWithFieldsInEmpties row, fields

    return row
  end

  def updateRowWithAllFieldsComplete row, fields
    row.each_with_index { |value, i|
      if value == 1
        matchingFields = []
        fields.each { |field|
          if field.minStart <= i && field.maxEnd >= i
            matchingFields << field
          end
        }

        if matchingFields.length == 1
          field = matchingFields[0]
          if field.minEnd < i
            field.minEnd = i
            field.updateMinStart
          end
          if field.maxStart > i
            field.maxStart = i
            field.updateMaxEnd
          end
        end
      end
    }

    return updateRowWithNotOverlappingFields row, fields
  end

  def updateRowWithFieldsInEmpties row, fields
    empties = []
    empty = nil
    row.each_with_index { |value, i|
      if value == -1
        if empty == nil
          empty = Field.new
          empties << empty
          empty.start = i
        end
        empty.end = i
      else
        empty = nil
      end
    }

    fields.each { |field|
      emptiesMatching = []
      empties.each { |empty|
        if empty.start >= field.minStart && empty.start <= field.maxEnd
          emptiesMatching << empty
        end
      }

      if emptiesMatching.length > 0
        firstEmpty = emptiesMatching[0]
        lastEmpty = emptiesMatching[emptiesMatching.length - 1]
        if firstEmpty.start > field.minStart
          field.minStart = firstEmpty.start
          field.updateMinEnd
        end
        if lastEmpty.end < field.maxEnd
          field.maxEnd = lastEmpty.end
          field.updateMaxStart
        end
      end
    }
    return updateRowWithOverlappingFields row, fields
  end

  def updateRowWithNotOverlappingFields row, fields
    mask = []
    row.each {
      mask << 0
    }

    fields.each { |field|
      (field.minStart..field.maxEnd).each { |i|
        mask[i] = 1
      }
    }

    mask.each_with_index { |value, i|
      if value == 0
        row[i] = 0
      end
    }

    return row
  end

  def initMinIndex encodedRow
    fields = []
    minStart = 0
    encodedRow.each { |fieldLength|
      field = Field.new
      field.length = fieldLength
      field.minStart = minStart
      field.updateMinEnd
      minStart = field.minEnd + 2
      fields << field
    }
    return fields
  end

  def initMaxIndex row, fields, encodedRow
    maxEnd = row.length - 1
    encodedRow.reverse.each_with_index { |fieldLength, i|
      field = fields.reverse[i]
      field.maxEnd = maxEnd
      field.updateMaxStart
      maxEnd = field.maxStart - 2
    }
    return fields
  end

  def updateRowWithOverlappingFields row, fields
    fields.each { |field|
      if field.maxStartOverlapMinEnd
        (field.maxStart..field.minEnd).each { |i|
          row[i] = 1
        }
      end
    }
    return row
  end

  def decodeImage encodedImage, image
    horizontal = encodedImage[0]
    vertical = encodedImage[1]

    vertical.each_with_index { |x, i|
      column = decodeRow getColumn(image, i), x
      image = insertColumn image, column, i
    }

    horizontal.each_with_index { |y, i|
      image[i] = decodeRow image[i], y
    }

    return image
  end
end
