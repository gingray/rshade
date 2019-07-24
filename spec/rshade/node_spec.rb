RSpec.describe RShade::Node, focus: true do
  describe '.clone_by' do
    subject { RShade::Trace.new }

    before do
      subject.reveal do
        TestRshade.call
      end
    end

    it do
      clone = subject.show_only_app_code
      expect(clone).to eq nil
    end
  end
end
