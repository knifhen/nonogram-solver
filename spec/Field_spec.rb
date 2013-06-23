require 'Field'

describe Field do
  it "can exist before" do
    field = Field.new
    field.minStart = 0
    field.minEnd = 1
    field.maxStart = 2
    field.maxEnd = 3
    field.length = 2
    row = [-1, -1, 0, -1]
    (field.canExistBefore 2, row).should be true
  end

  it "can't exist before" do
    field = Field.new
    field.minStart = 0
    field.minEnd = 1
    field.maxStart = 2
    field.maxEnd = 3
    field.length = 2
    row = [0, -1, 0, -1]
    (field.canExistBefore 2, row).should be false
  end

  it "can exist after" do
    field = Field.new
    field.minStart = 0
    field.minEnd = 1
    field.maxStart = 2
    field.maxEnd = 4
    field.length = 2
    row = [0, -1, 0, -1, -1]
    (field.canExistAfter 2, row).should be true
  end
  it "can't exist after" do
    field = Field.new
    field.minStart = 0
    field.minEnd = 1
    field.maxStart = 2
    field.maxEnd = 4
    field.length = 2
    row = [-1, -1, 0, -1, 0]
    (field.canExistAfter 2, row).should be false
  end
end
