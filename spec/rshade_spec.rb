RSpec.describe RShade, focus: true do
  subject { RShade::Trace.new }

  it "has a version number", focus: true do
    subject.reveal do
      TestRshade.new.some
    end
  end
end
