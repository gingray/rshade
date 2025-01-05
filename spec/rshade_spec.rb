# frozen_string_literal: true

RSpec.describe RShade do
  context 'use implicit reveal' do
    let(:result) do
      RShade::Trace.reveal do
        TestRshade.call
      end
    end

    it 'show report' do
      expect(result).to be_kind_of RShade::Trace
      result.show
    end
  end

  context 'use explicit reveal', focus: true do
    it do
      expect(TestRshade4.new.call(1)).to eq 3
    end
  end
end
