# frozen_string_literal: true

RSpec.describe RShade::EventTree do
  let(:store) { RShade::EventTree.new }

  context 'add element to the store should return one element' do
    let(:sequence) { [1] }
    before do
      sequence.map { |item| RShade::Event.new({ level: item, vars: {} }) }.each do |event|
        store.add event, event.level
      end
    end
    it do
      expect(store.count).to eq 1
    end
  end

  context 'events go without jumps' do
    let(:sequence) { [1, 2, 3, 2, 1] }
    before do
      sequence.map { |item| RShade::Event.new({ level: item, vars: {} }) }.each do |event|
        store.add event, event.level
      end
    end
    it do
      expect(store.map(&:level)).to eq [1, 2, 3, 2, 1]
    end
  end

  context 'events go with jumps to forward' do
    context 'check levels sequence' do
      let(:sequence) { [1, 2, 5, 2, 1] }
      before do
        sequence.map { |item| RShade::Event.new({ level: item, vars: {} }) }.each do |event|
          store.add event, event.level
        end
      end
      it do
        expect(store.map(&:level)).to eq [1, 2, 3, 4, 5, 2, 1]
      end
    end
  end

  context 'check vlevels sequence' do
    let(:sequence) { [1, 2, 5, 2, 1] }
    before do
      sequence.map { |item| RShade::Event.new({ level: item, vars: {} }) }.each do |event|
        store.add event, event.level
      end
    end
    it do
      expect(store.map(&:vlevel)).to eq [1, 2, 3, 3, 3, 2, 1]
    end
  end
end
