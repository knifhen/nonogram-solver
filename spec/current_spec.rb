require 'NonogramSolver'

describe NonogramSolver do
  it "" do
    correctRow = [-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,0,0,-1]
    encodedRow = [1,4,1]
    row = [-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,0,0,-1]
    ns = NonogramSolver.new
    ns.decodeRow row, encodedRow
    row.should eq(correctRow)
  end
end
