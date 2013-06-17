class NonogramSolver
  def main
    clearScreen

    encodedImage = [[[2],[4],[4],[2]], [[2],[4],[4],[2]]]
    #encodedImage = [[[1,1],[0],[0],[1,1]], [[1,1],[0],[0],[1,1]]]

    image = initImage encodedImage
    image = decodeImage encodedImage, image

    #image = [[0,1,1,0], [1,1,1,1], [1,1,1,1], [0,1,1,0]]
    printImage image
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
        row << 0
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

  def solveVerticalPixel column, x
    return column
  end

  def solveHorizontalPixel row, y
    min = []
    max = []

    nFields = y.length
    totalLength = [nFields - 1, 0].max
    encodedPixels = 0
    y.each_with_index { |field, i|
      encodedPixels += field
      min << 0
      max << row.length
    }
    totalLength += encodedPixels

    decodedPixels = 0
    row.each { |pixel|
      decodedPixels += pixel
    }

    if encodedPixels == decodedPixels
      return row
    end
    missingPixels = encodedPixels - decodedPixels

    return row
  end

  def decodeImage encodedImage, image
    horizontal = encodedImage[0]
    vertical = encodedImage[1]

    vertical.each_with_index { |x, i|
      column = solveVerticalPixel getColumn(image, i), x
      image = insertColumn image, column, i
    }

    horizontal.each_with_index { |y, i|
      image[i] = solveHorizontalPixel image[i], y
    }

    return image
  end
end
