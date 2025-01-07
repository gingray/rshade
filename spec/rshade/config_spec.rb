# frozen_string_literal: true

RSpec.describe RShade::Config do
  context 'check config creation' do
    let(:formatter) { double }
    let(:config) do
      RShade::Config.create.exclude_paths { |paths| paths << '123' }
                    .include_paths { |paths| paths << '321' }
                    .formatter { formatter }
                    .value
    end

    xit do
      filters = config.filter_composition.to_a
      expect(filters[0]).to be_a(RShade::Filter::IncludePathFilter)
      expect(filters[1]).to be_a(RShade::Filter::ExcludePathFilter)
      expect(config.formatter).to eq formatter
    end
  end

  context 'check config creation with default values' do
    let(:config) { RShade::Config.create_with_default.value }

    xit do
      filters = config.filter_composition.to_a
      expect(filters[0]).to be_a(RShade::Filter::ExcludePathFilter)
      expect(config.formatter).to be_a(RShade::Formatter::Trace::Stdout)
    end
  end

  context 'check default filter ignore gems events' do
    let(:service) { RShade::Config.default.filter_composition }
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
    let(:service) { RShade::Config.default.filter_composition }
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
