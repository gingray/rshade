RSpec.describe RShade::EventStore, focus: true do
  let(:store) { RShade::EventStore.new }
  before do
    sequence.map { |item| OpenStruct.new({level: item}) }.each do |event|
      store << event
    end
  end

  context "events go without jumps" do
    let(:sequence) { [1,2,3,2,1] }
    it do
      expect(store.map { |node| node.event.level }).to eq [1,2,3,2,1]
    end
  end

  context "events go with jumps to forward" do
    let(:sequence) { [1,2,5,2,1] }
    it do
      expect(store.map { |node| node.event.level }).to eq [1,2,3,4,5,2,1]
    end
  end

end
