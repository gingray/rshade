# frozen_string_literal: true

require 'rspec'

RSpec.describe 'RShade::Formatter::Stack::Json', focus: true do
  context 'when condition' do
    it 'succeeds' do
      expect(TestStacktraceSourceJsOn.new.call(10)).to eq 3
    end
  end
end
