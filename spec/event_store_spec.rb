RSpec.describe RShade::EventStore do
  let(:store) { RShade::EventStore.new }

  context "events go without jumps" do
    let(:sequence) { [1,2,3,2,1] }
      before do
        sequence.map { |item| OpenStruct.new({level: item}) }.each do |event|
          store << event
        end
      end
    it do
      expect(store.map { |node| node.event.level }).to eq [1,2,3,2,1]
    end
  end

  context "events go with jumps to forward" do
    context "check levels sequence" do
      let(:sequence) { [1,2,5,2,1] }
      before do
        sequence.map { |item| OpenStruct.new({level: item}) }.each do |event|
          store << event
        end
      end
      it do
        expect(store.map { |node| node.event.level }).to eq [1,2,3,4,5,2,1]
      end
    end
    end

    context "check vlevels sequence" do
      let(:sequence) { [1,2,5,2,1] }
      before do
        sequence.map { |item| OpenStruct.new({level: item}) }.each do |event|
          store << event
        end
      end
      it do
        expect(store.map { |node| node.vlevel }).to eq [1,2,3,3,3,2,1]
      end
    end
end
