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
    encodedColumns = encodedImage[0]
    encodedRows = encodedImage[1]

    image = decodeColumns image, encodedColumns
    image = decodeRows image, encodedRows

    if (imageDecoded image) || depth > image[0].length
      return image
    else
      return decodeImage encodedImage, image, depth + 1
    end
  end

  def decodeColumns image, encodedColumns
    encodedColumns.each_with_index { |x, i|
      column = decodeRow getColumn(image, i), x
      image = insertColumn image, column, i
    }
    return image
  end

  def decodeRows image, encodedRows
    encodedRows.each_with_index { |y, i|
      image[i] = decodeRow image[i], y
    }
    return image
  end


  def decodeRow row, encodedRow
    fields = initMinIndex encodedRow
    fields = initMaxIndex row, fields, encodedRow
    fields = updateFieldsWithPartOfFieldSet row, fields
    fields = updateCompleteFields row, fields

    row = updateRowWithOverlappingFields row, fields
    row = updateRowWithNotOverlappingFields row, fields
    row = updateRowWithFieldsInFreeSpace row, fields
    row = updateRowWithAllFieldsComplete row, fields

    return row
  end

  def updateFieldsWithPartOfFieldSet row, fields
    fields.each { |field|
      (field.minStart..field.maxEnd).each { |i|
        if row[i] == 0
          if !field.canExistBefore i, row
            field.setMinStart i + 1
          elsif !field.canExistAfter i, row
            field.setMaxEnd i - 1
          end
        elsif row[i] == 1
          if field.isOnlyMatchingField fields, i
            field.updateSpanWithIndex i
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

    fields.each_with_index { |field, i|
      if field.isComplete && !fieldIsLast(fields, i) && !fields[i+1].isComplete
        nextField = fields[i+1]
        if nextField.minStart < field.maxEnd + 2
          nextField.setMinStart field.maxEnd + 2
        end
      elsif !fieldIsLast(fields, i) && !fields[i+1].isComplete
        nextField = fields[i+1]
        if nextField.minStart < field.minEnd + 2
          nextField.setMinStart field.minEnd + 2
        end
      end
    }

    return fields
  end

  def fieldIsLast fields, i
    return fields.length == i + 1
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

  def printImageAndEncoding image, encodedImage
    mostValuesInCol = 0
    encodedImage[0].each { |encodedCol|
      mostValuesInCol = [mostValuesInCol, encodedCol.length].max
    }
    mostValuesInRow = 0
    encodedImage[1].each { |encodedRow|
      mostValuesInRow = [mostValuesInRow, encodedRow.length].max
    }

    puts ""

    mostValuesInCol.downto(1) { |i|
      (0..mostValuesInRow).each {
        print " "
      }
      encodedImage[0].each { |encodedCol|
        if encodedCol.length >= i
          print encodedCol[encodedCol.length - i]
        else
          print " "
        end
      }
      puts ""
    }

    puts ""

    encodedImage[1].each_with_index { |encodedRow,i|
      (1..mostValuesInRow - encodedRow.length).each {
        print " "
      }
      encodedRow.each { |value|
        print value
      }

      print " "

      image[i].each { |pixel|
        if pixel == -1
          print 'x'
        else
          print pixel
        end
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
            field.setMinEnd i
          end
          if field.maxStart > i
            field.setMaxStart i
          end
        end
      end
    }
    return updateRowWithNotOverlappingFields row, fields
  end

  def updateRowWithFieldsInFreeSpace row, fields
    freeSpaces = []
    freeSpace = nil
    row.each_with_index { |value, i|
      if value != 0
        if freeSpace == nil
          freeSpace = Field.new
          freeSpaces << freeSpace
          freeSpace.start = i
        end
        freeSpace.end = i
        freeSpace.updateLength
      else
        freeSpace = nil
      end
    }

    fields.each { |field|
      if field.isComplete
        next
      end

      freeSpacesMatching = []
      freeSpaces.each { |freeSpace|
        if freeSpace.start <= field.maxEnd && freeSpace.end >= field.minStart && freeSpace.length >= field.length
          freeSpacesMatching << freeSpace
        end
      }

      if freeSpacesMatching.length > 0
        firstFreeSpace = freeSpacesMatching[0]
        lastFreeSpace = freeSpacesMatching[freeSpacesMatching.length - 1]
        if firstFreeSpace.start >= field.minStart && firstFreeSpace.start <= field.maxStart
          field.setMinStart firstFreeSpace.start
        end
        if lastFreeSpace.end <= field.maxEnd && lastFreeSpace.end >= field.minEnd
          field.setMaxEnd lastFreeSpace.end
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
      field.setMinStart minStart
      minStart = field.minEnd + 2
      fields << field
    }
    return fields
  end

  def initMaxIndex row, fields, encodedRow
    maxEnd = row.length - 1
    encodedRow.reverse.each_with_index { |fieldLength, i|
      field = fields.reverse[i]
      field.setMaxEnd maxEnd
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
