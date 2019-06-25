RSpec.describe RShade, focus: true do
  subject { RShade::Trace.new }

  it "has a version number", focus: true do
    subject.reveal do
      TestRshade.new.some
    end
  end

  it "check copy tree" do
    node = RShade::Node.new(nil)
    5.times do |n|
      item = RShade::Node.new(node)
      item.value = n
      node.nodes << item
    end

    copy = node.copy do |node|
      node.value >= 2
    end
    expect(copy.nodes.count).to eq 3
  end
end
