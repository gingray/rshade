# frozen_string_literal: true

RSpec.describe 'RShade::Serializer::Traversal' do
  let(:hash) { { test: 'test', arr: [1, 2, 3], custom_class: klass } }
  let(:klass) do
    Class.new
  end
  let(:custom_serializer) { ->(_value) { 'custom-serializer' } }
  let(:service) { RShade::Serializer::Traversal.new({ klass => custom_serializer }) }
  context 'serialize success' do
    it do
      expect(service.call(hash)).to eq({ test: 'test', arr: [1, 2, 3], custom_class: 'custom-serializer' })
    end
  end
end
