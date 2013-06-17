require 'NonogramSolver'

describe NonogramSolver, "Solve row" do
  it "Solves the cross image" do
    correctImage = [[0,1,1,0], [1,1,1,1], [1,1,1,1], [0,1,1,0]]
    encodedImage = [[[2],[4],[4],[2]], [[2],[4],[4],[2]]]
    ns = NonogramSolver.new
    image = ns.solve encodedImage
    image.should eq(correctImage)
  end
end
