require 'NonogramSolver'

describe NonogramSolver do

  it "solves field with freeSpace in middle" do
    correctRow = [0,1,1,1,0,-1,-1,1,1,-1,-1,0,1,1,1]
    encodedRow = [3,4,3]
    row = [0,1,-1,1,-1,-1,-1,1,-1,-1,-1,0,1,-1,1]
    ns = NonogramSolver.new
    row = ns.decodeRow row, encodedRow
    row.should eq(correctRow)
  end
end
