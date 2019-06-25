RSpec.describe RShade::SourceNode, focus: true do
  context 'remove gems calls' do
    let(:json) { JSON.parse(file_fixture_read("source_graph_1.json")) }
    let(:source_node) {create_source_node(json, nil) }
    it do
      expect(source_node).to be_a RShade::SourceNode
    end
  end
end
