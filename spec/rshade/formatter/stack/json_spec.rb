# frozen_string_literal: true

require 'rspec'

RSpec.describe 'RShade::Formatter::Stack::Json', focus: true do
  context 'when condition' do
    let(:filepath) { File.join(spec_store_path, 'json_store.json') }

    before do
      config = ::RShade::Config::StackStore.new
      config.set_formatter(::RShade::Formatter::Stack::Json.new(filepath:))
      ::RShade::Config::Registry.instance.set_default_stack(config)
    end
    it 'succeeds' do
      expect(TestStacktraceSourceJsOn.new.call(1)).to eq 4
    end
  end
end
