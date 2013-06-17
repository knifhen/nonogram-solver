require 'NonogramSolver'

describe NonogramSolver, "Decode nonogram image" do
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
    pending
    correctRow = [1,0,0,1]
    encodedRow = [1,1]
    row = [1,-1,-1,1]
    ns = NonogramSolver.new
    ns.decodeRow row, encodedRow
    row.should eq(correctRow)
  end

  it "Solves the cross image" do
    pending
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

end
