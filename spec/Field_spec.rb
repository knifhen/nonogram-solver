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

  it "spans index" do
    field = Field.new
    field.length = 2
    field.setMinStart 0
    field.setMaxStart 2

    (field.spansIndex 2).should be true
    (field.spansIndex 4).should be false
  end

  it "is only matching field" do
    fields = []

    matchingField = Field.new
    matchingField.length = 2
    matchingField.setMinStart 0
    matchingField.setMaxStart 2

    fields << matchingField

    notMatchingField = Field.new
    notMatchingField.length = 1
    notMatchingField.setMinStart 2
    notMatchingField.setMaxStart 3

    fields << notMatchingField

    (matchingField.isOnlyMatchingField fields, 1).should be true
    (notMatchingField.isOnlyMatchingField fields, 1).should be false
  end

  it "updates span to match index" do
    field = Field.new
    field.length = 2
    field.setMinStart 0
    field.setMaxStart 3

    field.updateSpanWithIndex 2
    field.maxStart.should be 2
    field.maxEnd.should be 3
    field.minStart.should be 1
    field.minEnd.should be 2
  end
end
