# frozen_string_literal: true

require 'rspec'

RSpec.describe 'RShade::Formatter::Stack::Json' do
  context 'when condition' do
    let(:filepath) { File.join(spec_store_path, 'json_store.json.log') }

    before do
      ::RShade::Config::Registry.instance.stack_config do |config|
        config.formatter!(:json, { filepath: filepath, pretty: true })
      end
    end
    it 'succeeds' do
      expect(TestStacktraceSourceJsOn.new.call(1)).to eq 4
    end
  end
end
