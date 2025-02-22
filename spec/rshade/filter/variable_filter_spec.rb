# frozen_string_literal: true

RSpec.describe RShade::Filter::VariableFilter do
  let(:formatter) { TestFormatter.new }
  let(:base_config) do
    var_filter = RShade::Filter::FilterComposition.new(RShade::Filter::VariableFilter.new)
    comp = RShade::Filter::FilterComposition.new(:unary, var_filter)
    RShade::Config::EventStore.new(filter: comp).formatter!(formatter)
  end

  context 'variable name' do
    let(:config) do
      base_config.filter!(RShade::Filter::VariableFilter) do |name, _value|
        name == :x
      end
    end

    let(:result) do
      RShade::Trace.reveal(config: config) do
        TestRshade3.call
      end
    end

    it 'match' do
      expect(result).to be_kind_of RShade::Trace
      result.show
      expect(formatter.event_store.count).to eq 2
    end
  end

  context 'variable value' do
    let(:config) do
      base_config.filter!(RShade::Filter::VariableFilter) do |_name, value|
        value == 3
      end
    end

    let(:result) do
      RShade::Trace.reveal(config: config) do
        TestRshade3.call
      end
    end

    it 'match' do
      expect(result).to be_kind_of RShade::Trace
      result.show
      expect(formatter.event_store.count).to eq 1
    end
  end

  context 'variable value' do
    let(:config) do
      base_config.filter!(RShade::Filter::VariableFilter) do |_name, value|
        value == 4
      end
    end

    let(:result) do
      RShade::Trace.reveal(config: config) do
        TestRshade3.call
      end
    end

    it 'not match' do
      expect(result).to be_kind_of RShade::Trace
      result.show
      expect(formatter.event_store.count).to eq 0
    end
  end

  context 'variable name' do
    let(:config) do
      base_config.filter!(RShade::Filter::VariableFilter) do |name, _value|
        name == :z
      end
    end

    let(:result) do
      RShade::Trace.reveal(config: config) do
        TestRshade3.call
      end
    end

    it 'not match' do
      expect(result).to be_kind_of RShade::Trace
      result.show
      expect(formatter.event_store.count).to eq 0
    end
  end
end
