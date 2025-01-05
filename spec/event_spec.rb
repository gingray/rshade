# frozen_string_literal: true

RSpec.describe RShade::Event do
  let(:hash) { { klass: 'Test', lineno: 10, path: 'test.rb', method_name: 'call', vars: { x: 1 }, level: 1 } }

  describe '.new' do
    let(:event) { RShade::Event.new(hash) }

    it do
      expect(event.klass).to eq 'Test'
      expect(event.lineno).to eq 10
      expect(event.path).to eq 'test.rb'
      expect(event.method_name).to eq 'call'
      expect(event.vars).to eq({ x: 1 })
      expect(event.level).to eq 1
    end
  end

  describe '.with_level' do
    let(:event) { RShade::Event.new(hash) }
    it do
      event.with_level!(10)
      expect(event.level).to eq 10
    end
  end
end
