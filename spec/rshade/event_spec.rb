RSpec.describe RShade::Event, focus: true do
  describe '.clone_by' do
    subject { RShade::Trace.new }

    before do
      subject.reveal do
        TestRshade.call
      end
    end

    it do
      clone = subject.show
      expect(clone).to eq nil
    end
  end
end
