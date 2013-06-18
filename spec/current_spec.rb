require 'NonogramSolver'

describe NonogramSolver do
  it "" do
    correctRow = [1,1,1,0,0,0,0,1,0,1]
    encodedRow = [3,1,1]
    row = [1,1,1,0,0,0,0,1,0,-1]
    ns = NonogramSolver.new
    row = ns.decodeRow row, encodedRow
    row.should eq correctRow
  end
end
