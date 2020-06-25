RSpec.describe RShade::Formatter::Html, focus: true do
  let(:formatter) { double }

  let(:json) { [1,2,3] }
  let(:service) { RShade::Formatter::Html.new({}, formatter: formatter) }

  context 'check html template generation' do
    before { allow(formatter).to receive(:call).and_return(json) }
    before do
      expect(service).to receive(:write_to_file) do |arg|
        arg
      end
    end

    it do
      val = service.call
      expect(val).to be_kind_of(String)
      expect(val).to match(Regexp.escape "var data = [1,2,3];")
    end
  end
end