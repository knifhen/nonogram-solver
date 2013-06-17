require 'NonogramSolver'

describe NonogramSolver do
  it "Solves row A" do
    correctRow = [1,1,1,1]
    encodedRow = [4]
    row = [-1,-1,-1,-1]
    ns = NonogramSolver.new
    row = ns.decodeRow row, encodedRow
    row.should eq(correctRow)
  end

  it "Solves row B" do
    correctRow = [1,0,1]
    encodedRow = [1,1]
    row = [-1,-1,-1]
    ns = NonogramSolver.new
    row = ns.decodeRow row, encodedRow
    row.should eq(correctRow)
  end

  it "Solves row with all nonoverlapping fields set" do
    correctRow = [1,0,0,1]
    encodedRow = [1,1]
    row = [-1,0,0,-1]
    ns = NonogramSolver.new
    ns.decodeRow row, encodedRow
    row.should eq(correctRow)
  end

  it "Solves row with all overlapping fields set" do
    correctRow = [1,0,0,1]
    encodedRow = [1,1]
    row = [1,-1,-1,1]
    ns = NonogramSolver.new
    ns.decodeRow row, encodedRow
    row.should eq(correctRow)
  end

  it "Solves the cross image" do
    correctImage = [[0,1,1,0], [1,1,1,1], [1,1,1,1], [0,1,1,0]]
    encodedImage = [[[2],[4],[4],[2]], [[2],[4],[4],[2]]]
    ns = NonogramSolver.new
    image = ns.solve encodedImage
    image.should eq(correctImage)
  end

  it "Solves the corners image" do
    correctImage = [[1,0,0,1], [0,0,0,0], [0,0,0,0], [1,0,0,1]]
    encodedImage = [[[1,1],[],[],[1,1]],[[1,1],[],[],[1,1]]]
    ns = NonogramSolver.new
    image = ns.solve encodedImage
    image.should eq(correctImage)
  end

  it "decodes row without increasing row length" do
    encodedRow = [1,2]
    row = [-1, -1, -1, 1, -1]
    ns = NonogramSolver.new
    row = ns.decodeRow row, encodedRow
    row.length.should eq 5
  end

  it "solves row with only one empty matching field" do
    correctRow = [-1,0,0,1,1]
    encodedRow = [2]
    row = [-1,0,0,-1,-1]
    ns = NonogramSolver.new
    row = ns.decodeRow row, encodedRow
    row.should eq correctRow
  end

  it "Solves random easy problem" do
    encodedImage = [[[3],[2],[4],[1],[1,2]], [[1,1],[3],[3],[1,1,1],[2]]]
    ns = NonogramSolver.new
    image = ns.solve encodedImage
    image.should notContainEmpties
    image.should haveSize 5, 5
    ns.printImage image
  end

  RSpec::Matchers.define :haveSize do |width, height|
    match { |image|
      image.length.should eq height
      image.each { |row|
        row.length.should eq width
      }
    }
  end

  RSpec::Matchers.define :notContainEmpties do
    match { |image|
      image.each { |row|
        row.each { |value|
          value.should_not eq(-1)
        }
      }
    }
  end

end
