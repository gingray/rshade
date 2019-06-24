RSpec.describe Rshade do
  subject { Rshade::Trace.new }

  it "has a version number", focus: true do
    subject.reveal do
      TestRshade.new.some
    end
    binding.pry
  end

  it "does something useful" do
    expect(false).to eq(true)
  end
end
