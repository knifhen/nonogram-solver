require 'Field'

class NonogramSolver
  def main
    clearScreen

    encodedImage = [[[2,2,4],[6,3],[2,3,1,1],[8,1],[1,2],[2,5],[7],[3,2,1],[3,1],[1,1,1,2,1],[3,6],[1,5],[2,8,1],[2,3,2,2],[6,3,3]],
                    [[1,3],[1,3],[4,2,1],[5,5],[1,1,1,3],[3,4,3],[4,4,3],[4,8],[1,5],[2,6],[1,9,1],[1,4,1],[2,1,1],[2,1,3],[4,1,1,2]]]

    image = solve encodedImage

    printImage image
  end

  def solve encodedImage
    image = initImage encodedImage
    image = decodeImage encodedImage, image, 0
    return image
  end

  def decodeImage encodedImage, image, depth
    puts "#{depth}"
    horizontal = encodedImage[0]
    vertical = encodedImage[1]

    horizontal.each_with_index { |x, i|
      column = decodeRow getColumn(image, i), x
      image = insertColumn image, column, i
    }

    printImage image

    vertical.each_with_index { |y, i|
      image[i] = decodeRow image[i], y
    }

    printImage image

    if (imageDecoded image) || depth > image[0].length
      return image
    else
      return decodeImage encodedImage, image, depth + 1
    end

  end

  def decodeRow row, encodedRow
    fields = initMinIndex encodedRow
    fields = initMaxIndex row, fields, encodedRow
    fields = updateFieldsSpanningNoZone row, fields
    fields = updateCompleteFields row, fields

    row = updateRowWithOverlappingFields row, fields
    row = updateRowWithNotOverlappingFields row, fields
    row = updateRowWithAllFieldsComplete row, fields
    row = updateRowWithFieldsInEmpties row, fields

    return row
  end

  def updateFieldsSpanningNoZone row, fields
    fields.each { |field|
      (field.minStart..field.maxEnd).each { |i|
        if row[i] == 0
          if i - field.minStart < field.length
            field.minStart = i + 1
            field.updateMinEnd
            break
          end
        end
      }
      (field.minStart..field.maxEnd).each { |i|
        if row[i] == 0
          if field.maxEnd - i < field.length
            field.maxEnd = i - 1
            field.updateMaxStart
            break
          end
        end
      }
    }


    return fields
  end

  def updateCompleteFields row, fields
    completeFieldsForward = []
    completeField = nil
    row.each_with_index { |value,i|
      if value == -1
        break
      elsif value == 0
        completeField = nil
      else
        if completeField == nil
          completeField = Field.new
          completeFieldsForward << completeField
          completeField.start = i
        end
        completeField.end = i
        completeField.updateLength
      end
    }

    fields.each_with_index { |field,i|
      if completeFieldsForward.length > i
        completeField = completeFieldsForward[i]
        if field.length == completeField.length
          field.minStart = completeField.start
          field.maxStart = completeField.start
          field.minEnd = completeField.end
          field.maxEnd = completeField.end
        end
      else
        break
      end
    }

    fields.each_with_index { |field,i|
      if field.isComplete && fields.length > i + 1 && !fields[i+1].isComplete
        incompleteField = fields[i+1]
        if incompleteField.minStart <= field.minStart + 1
          incompleteField.minStart = field.minStart + 2
          incompleteField.updateMinEnd
        end
      end
    }

    return fields
  end

  def clearScreen
    puts "\e[H\e[2J"
  end

  def printImage image
    puts ""
    image.each { |row|
      row.each { |pixel|
        if pixel == -1
          print 'x'
        else
          print pixel
        end
      }
      puts ""
    }
    puts ""
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
      if value != 0
        if empty == nil
          empty = Field.new
          empties << empty
          empty.start = i
        end
        empty.end = i
        empty.updateLength
      else
        empty = nil
      end
    }

    fields.each { |field|
      if field.isComplete
        next
      end

      emptiesMatching = []
      empties.each { |empty|
        # bug in here, matching empty can start before field and end after field
        if empty.start >= field.minStart && empty.start <= field.maxEnd && empty.length >= field.length
          emptiesMatching << empty
        end
      }

      if emptiesMatching.length > 0
        firstEmpty = emptiesMatching[0]
        lastEmpty = emptiesMatching[emptiesMatching.length - 1]
        if firstEmpty.start >= field.minStart && firstEmpty.start <= field.maxStart
          field.minStart = firstEmpty.start
          field.updateMinEnd
        end
        if lastEmpty.end <= field.maxEnd && lastEmpty.end >= field.minEnd
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

  def imageDecoded image
    image.each { |row|
      row.each { |value|
        if value == -1
          return false
        end
      }
    }
    return true
  end

end
