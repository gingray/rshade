RSpec.describe RShade::Filter::FilterComposition, focus: true do
  let(:event) { true }
  context "when 'true and false'" do
    let(:composition) do
      RShade::Filter::FilterComposition.build([:and, ->(event) { event }, ->(event) { !event }])
    end
    it 'should be false' do
      expect(composition.call(event)).to eq false
    end
  end

  context "when 'true and true'" do
    let(:composition) do
      RShade::Filter::FilterComposition.build([:and, ->(event) { event }, ->(event) { event }])
    end
    it 'should be false' do
      expect(composition.call(event)).to eq true
    end
  end

  context "when 'false and false'" do
    let(:composition) do
      RShade::Filter::FilterComposition.build([:and, ->(event) { !event }, ->(event) { !event }])
    end
    it 'should be false' do
      expect(composition.call(event)).to eq false
    end
  end

  context "when 'false or true'" do
    let(:composition) do
      RShade::Filter::FilterComposition.build([:or, ->(event) { !event }, ->(event) { event }])
    end
    it 'should be false' do
      expect(composition.call(event)).to eq true
    end
  end

  context "complex filter" do
    let(:composition) do
      RShade::Filter::FilterComposition.build([:and, [:and, ->(event) { event }, ->(event) { event }], ->(event) { event }])
    end
    it 'should be false' do
      expect(composition.call(event)).to eq true
    end
  end

  context "event filter composition" do
    let(:event) { RShade::Event.new({vars: {x: nil}})}
    let(:composition) do
      filter1 = RShade::Filter::VariableFilter.new
      filter2 = RShade::Filter::IncludePathFilter.new

      comp = RShade::Filter::FilterComposition
      comp.new(:or, RShade::Filter::FilterComposition.new(filter1), RShade::Filter::FilterComposition.new(filter2))
    end

    before do
      composition.config_filter(RShade::Filter::VariableFilter) do |name, value|
        name == :x
      end
    end
    it 'should be false' do
      expect(composition.call(event)).to eq true
    end
  end
end
