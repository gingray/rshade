# frozen_string_literal: true

require 'rspec'

module ModulePatcher
  class TestPatcher
    def self.call2(arg1, arg2)
      [arg1, arg2].reduce(:*)
    end

    def call(arg1, arg2)
      [arg1, arg2].reduce(:+)
    end
  end
end

RSpec.describe 'RShade::Patcher::ObjectPatcher', focus: true do
  context 'when instance patch through prepend' do
    let(:result) { [] }
    before do
      RShade::Patcher::ObjectPatcher.new.patch(ModulePatcher::TestPatcher, :call, :inst) do |*args|
        RShade::Stack.trace
        result << args
      end
    end

    it 'succeeds' do
      expect(ModulePatcher::TestPatcher.new.call(1, 3)).to eq 4
      expect(result).to eq [[1, 3]]
    end
  end

  context 'when singleton method patch through prepend', focus: true do
    let(:result) { [] }
    before do
      RShade::Patcher::ObjectPatcher.new.patch(ModulePatcher::TestPatcher, :call2, :class) do |*args|
        RShade::Stack.trace
        result << args
      end
    end

    it 'succeeds' do
      expect(ModulePatcher::TestPatcher.call2(2, 3)).to eq 6
      expect(result).to eq [[2, 3]]
    end
  end
end
