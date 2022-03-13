RSpec.describe RShade::Filter::VariableFilter, focus: true do
  context "match by variable name" do
    let(:config) do
      ::RShade::Config.create.match_variable do |name, value|
        name == :x
      end.exclude_paths {  |paths| paths << /test/ }
    end

    let(:result) do
      RShade::Trace.reveal(config) do
        TestRshade3.call
      end
    end

    it "match variable by name" do
      expect(result).to be_kind_of RShade::Trace
      result.show
    end
  end

  context "match by variable value" do
    let(:config) do
      ::RShade::Config.create.match_variable do |name, value|
        value == 3
      end.exclude_paths {  |paths| paths << /test/ }
    end

    let(:result) do
      RShade::Trace.reveal(config) do
        TestRshade3.call
      end
    end

    it "match variable by name" do
      expect(result).to be_kind_of RShade::Trace
      result.show
    end
  end
end
