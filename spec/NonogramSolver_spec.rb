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

  it "solves field with freeSpace in middle" do
    correctRow = [0,1,1,1,0,-1,-1,1,1,-1,-1,0,1,1,1]
    encodedRow = [3,4,3]
    row = [0,1,-1,1,-1,-1,-1,1,-1,-1,-1,0,1,-1,1]
    ns = NonogramSolver.new
    decodedRow = ns.decodeRow row, encodedRow
    decodedRow.should eq correctRow

    decodedRow = ns.decodeRow row.reverse, encodedRow.reverse
    decodedRow.should eq correctRow.reverse
  end

  it "solves problem where field should not be overlapping minEnd of field before " do
    correctRow = [0,0,0,0,0,1,1,1,0,0,1,1,0,0,1]
    encodedRow = [3,2,1]
    row = [0,0,0,0,0,1,1,1,0,-1,1,1,0,0,-1]
    ns = NonogramSolver.new
    decodedRow = ns.decodeRow row, encodedRow
    decodedRow.should eq correctRow
  end


end
