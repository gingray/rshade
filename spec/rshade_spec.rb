RSpec.describe RShade do
  subject { RShade::Trace.new }

  it "has a version number", focus: true do
    subject.reveal do
      TestRshade.new.some
    end
  end

  it "check copy tree" do
    node = RShade::SourceNode.new(nil)
    5.times do |n|
      item = RShade::SourceNode.new(node)
      item.value = n
      node.nodes << item
    end

    copy = node.duplicate do |node|
      node.value >= 2
    end
    expect(copy.nodes.count).to eq 3
  end
end
