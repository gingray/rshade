RSpec.describe RShade do
  subject { RShade::Trace.new }

  it "has a version number" do
    subject.reveal do
      TestRshade.call
    end
    expect(subject.show).to eq nil
  end
end
