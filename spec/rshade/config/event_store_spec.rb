# frozen_string_literal: true

require 'rspec'

RSpec.describe 'RShade::Config::EventStore' do
  context 'check config creation' do
    let(:formatter) { double }
    let(:config) do
      RShade::Config::EventStore.new.filter!(RShade::Filter::ExcludePathFilter) { |paths| paths << '123' }
                                .filter!(RShade::Filter::IncludePathFilter) { |paths| paths << '321' }
                                .formatter!(formatter)
    end

    xit do
      filters = config.filter_composition.to_a
      expect(filters[0]).to be_a(RShade::Filter::IncludePathFilter)
      expect(filters[1]).to be_a(RShade::Filter::ExcludePathFilter)
      expect(config.formatter).to eq formatter
    end
  end

  context 'check config creation with default values' do
    let(:config) { RShade::Config::EventStore.default }

    xit do
      filters = config.filter_composition.to_a
      expect(filters[0]).to be_a(RShade::Filter::ExcludePathFilter)
      expect(config.formatter).to be_a(RShade::Formatter::Trace::Stdout)
    end
  end

  context 'check default filter ignore gems events' do
    let(:service) { RShade::Config::EventStore.default.filter }
    let(:events) { [ruby_gem_event] }
    let(:ruby_gem_event) { double }
    before do
      allow(ruby_gem_event).to receive(:path).and_return('/Users/test/.rvm/gems/ruby-2.7.5/gems')
    end
    it 'succeeds' do
      expect(service.call(ruby_gem_event)).to eq false
    end
  end

  context 'check default filter ignore gems events when pattern just /gems/' do
    let(:service) { RShade::Config::EventStore.default.filter }
    let(:events) { [ruby_gem_event] }
    let(:ruby_gem_event) { double }
    before do
      allow(ruby_gem_event).to receive(:path).and_return('/Users/test/.rvm/gems/ruby/2.7.5/gems')
    end
    it 'succeeds' do
      expect(service.call(ruby_gem_event)).to eq false
    end
  end
end
