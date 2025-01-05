# frozen_string_literal: true

RSpec.describe 'RShade::Filter::FilterBuilder' do
  context 'build filter composition from array' do
    let(:arr) { [:or, ->(event) { event }, lambda(&:!)] }
    let(:service) { RShade::Filter::FilterBuilder.build(arr) }
    it 'succeeds' do
      expect(service).to be_a(RShade::Filter::FilterComposition)
      expect(service.call(true)).to eq true
    end
  end

  context 'default filter' do
    let(:arr) do
      [:or, [:or, RShade::Filter::VariableFilter, RShade::Filter::IncludePathFilter], RShade::Filter::ExcludePathFilter]
    end
    let(:service) { RShade::Filter::FilterBuilder.build(arr) }

    it do
      expect(service).to be_a RShade::Filter::FilterComposition
    end
  end
end
