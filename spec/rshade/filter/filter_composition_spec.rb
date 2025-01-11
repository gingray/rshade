# frozen_string_literal: true

RSpec.describe RShade::Filter::FilterComposition do
  let(:event) { true }
  context "when 'true and false'" do
    let(:composition) do
      RShade::Filter::FilterComposition.build([:and, ->(event) { event }, lambda(&:!)])
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
      RShade::Filter::FilterComposition.build([:and, lambda(&:!), lambda(&:!)])
    end
    it 'should be false' do
      expect(composition.call(event)).to eq false
    end
  end

  context "when 'false or true'" do
    let(:composition) do
      RShade::Filter::FilterComposition.build([:or, lambda(&:!), ->(event) { event }])
    end
    it 'should be false' do
      expect(composition.call(event)).to eq true
    end
  end

  context 'complex filter' do
    let(:composition) do
      RShade::Filter::FilterComposition.build([:and, [:and, ->(event) { event }, ->(event) { event }], lambda { |event|
                                                                                                         event
                                                                                                       }])
    end
    it 'should be false' do
      expect(composition.call(event)).to eq true
    end
  end

  context 'event filter composition' do
    let(:event) { RShade::Event.new({ vars: { x: { value: nil, name: :x, type: 'NilClass' } } }) }
    let(:composition) do
      filter1 = RShade::Filter::VariableFilter.new
      filter2 = RShade::Filter::IncludePathFilter.new

      comp = RShade::Filter::FilterComposition
      comp.new(:or, RShade::Filter::FilterComposition.new(filter1), RShade::Filter::FilterComposition.new(filter2))
    end

    before do
      composition.filter(RShade::Filter::VariableFilter) do |name, _value|
        name == :x
      end
    end
    it 'should be false' do
      expect(composition.call(event)).to eq true
    end
  end
end
