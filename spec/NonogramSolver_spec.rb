require 'NonogramSolver'

describe NonogramSolver do
  it "Solves row with field spanning entire row" do
    correctRow = [1,1,1,1]
    encodedRow = [4]
    row = [-1,-1,-1,-1]
    ns = NonogramSolver.new
    row = ns.decodeRow row, encodedRow
    row.should eq(correctRow)
  end

  it "Solves row with fields spanning entire row" do
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

  it "solves problem where an incomplete field is overlapping a complete field" do
    correctRow = [1,1,1,0,0,0,0,1,0,1]
    encodedRow = [3,1,1]
    row = [1,1,1,0,0,0,0,1,0,-1]
    ns = NonogramSolver.new
    row = ns.decodeRow row, encodedRow
    row.should eq correctRow
  end

  it "decodes row without increasing row length" do
    encodedRow = [1,2]
    row = [-1, -1, -1, 1, -1]
    ns = NonogramSolver.new
    row = ns.decodeRow row, encodedRow
    row.length.should eq 5
  end

  it "solves row with only one freeSpace matching field" do
    correctRow = [0,0,0,1,1]
    encodedRow = [2]
    row = [-1,0,0,-1,-1]
    ns = NonogramSolver.new
    row = ns.decodeRow row, encodedRow
    row.should eq correctRow
  end


end
