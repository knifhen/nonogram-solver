require 'NonogramSolver'

# http://www.puzzle-nonograms.com/ for examples
describe NonogramSolver do

  it "Solves the cross image" do
    correctImage = [[0,1,1,0], [1,1,1,1], [1,1,1,1], [0,1,1,0]]
    encodedImage = [[[2],[4],[4],[2]], [[2],[4],[4],[2]]]
    ns = NonogramSolver.new
    image = ns.solve encodedImage
    ns.printImageAndEncoding image, encodedImage
    image.should eq(correctImage)
    image.should beComplete encodedImage
  end

  it "Solves the corners image" do
    correctImage = [[1,0,0,1], [0,0,0,0], [0,0,0,0], [1,0,0,1]]
    encodedImage = [[[1,1],[],[],[1,1]],[[1,1],[],[],[1,1]]]
    ns = NonogramSolver.new
    image = ns.solve encodedImage
    ns.printImageAndEncoding image, encodedImage
    image.should eq(correctImage)
    image.should beComplete encodedImage
  end

  it "Solves random 5x5 problem" do
    encodedImage = [[[3],[2],[4],[1],[1,2]], [[1,1],[3],[3],[1,1,1],[2]]]
    ns = NonogramSolver.new
    image = ns.solve encodedImage
    ns.printImageAndEncoding image, encodedImage
    image.should notContainFreeSpace
    image.should haveSize 5, 5
    image.should beComplete encodedImage
  end

  it "Solves random 5x5 problem 2" do
    encodedImage = [[[3],[3],[1],[1,1],[3,1]], [[2],[1],[2,2],[2],[3,1]]]
    ns = NonogramSolver.new
    image = ns.solve encodedImage
    ns.printImageAndEncoding image, encodedImage
    image.should notContainFreeSpace
    image.should haveSize 5, 5
    image.should beComplete encodedImage
  end

  it "Solves random 10x10 problem" do
    encodedImage = [[[1,1,3],[5],[6],[5],[2,2,3],[1,4,2],[1,1,1,1],[1,1,1],[3],[3,1,1]], [[1,3,2],[1,2],[1,1,1,3],[3,1],[7],[6],[4,2],[5,1],[3],[1,1,1]]]
    ns = NonogramSolver.new
    image = ns.solve encodedImage
    ns.printImageAndEncoding image, encodedImage
    image.should notContainFreeSpace
    image.should haveSize encodedImage[0].length, encodedImage[1].length
    image.should beComplete encodedImage
  end

  it "Solves random 15x15 problem" do
    encodedImage = [[[2,2,4],[6,3],[2,3,1,1],[8,1],[1,2],[2,5],[7],[3,2,1],[3,1],[1,1,1,2,1],[3,6],[1,5],[2,8,1],[2,3,2,2],[6,3,3]],
                    [[1,3],[1,3],[4,2,1],[5,5],[1,1,1,3],[3,4,3],[4,4,3],[4,8],[1,5],[2,6],[1,9,1],[1,4,1],[2,1,1],[2,1,3],[4,1,1,2]]]
    ns = NonogramSolver.new
    image = ns.solve encodedImage
    ns.printImageAndEncoding image, encodedImage
    image.should notContainFreeSpace
    image.should haveSize encodedImage[0].length, encodedImage[1].length
    image.should beComplete encodedImage
  end

  RSpec::Matchers.define :haveSize do |width, height|
    match { |image|
      image.length.should eq height
      image.each { |row|
        row.length.should eq width
      }
    }
  end

  RSpec::Matchers.define :notContainFreeSpace do
    match { |image|
      image.each { |row|
        row.each { |value|
          value.should_not eq(-1)
        }
      }
    }
  end

  RSpec::Matchers.define :beComplete do |encodedImage|
    match { |image|
      ns = NonogramSolver.new
      encodedImage[0].each_with_index { |encodedRow,i|
        row = ns.getColumn image, i
        verifyRow row, encodedRow
      }
      encodedImage[1].each_with_index { |encodedRow,i|
        row = image[i]
        verifyRow row, encodedRow
      }
    }
  end

  def verifyRow row, encodedRow
    encodedRow.each { |length|
      fieldLength = 0
      row.each_with_index { |value,i|
        if value == 1
          fieldLength += 1
        elsif fieldLength > 0 && fieldLength == length
          (0..i).each { |index|
            row[index] = 0
          }
          break
        elsif fieldLength == 0 && value == 0
          next
        else
          fail "FieldLength should be #{length} but was #{fieldLength}"
        end
      }
    }
  end


end
