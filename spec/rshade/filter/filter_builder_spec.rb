RSpec.describe 'RShade::Filter::FilterBuilder', focus: true do
  let(:arr) { [:or, ->(event) { event }, ->(event) { !event }] }
  let(:service) { RShade::Filter::FilterBuilder.build(arr) }
  context 'build filter composition from array' do
    it 'succeeds' do
      expect(service).to be_a(RShade::Filter::FilterComposition)
      expect(service.call(true)).to eq true
    end
  end
end
