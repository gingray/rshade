RSpec.describe RShade::Filter::VariableFilter do
  let(:formatter) { TestFormatter.new }
  let(:base_config) do
    ::RShade::Config.create.formatter { formatter }.exclude_paths do |paths|
      paths << /.rb/
      paths << /internal/
    end
  end

  context "variable name" do
    let(:config) do
      base_config.match_variable do |name, value|
        name == :x
      end
    end

    let(:result) do
      RShade::Trace.reveal(config) do
        TestRshade3.call
      end
    end

    it "match" do
      expect(result).to be_kind_of RShade::Trace
      result.show
      expect(formatter.events.count).to eq 1
    end
  end

  context "variable value" do
    let(:config) do
      base_config.match_variable do |name, value|
        value == 3
      end
    end

    let(:result) do
      RShade::Trace.reveal(config) do
        TestRshade3.call
      end
    end

    it "match" do
      expect(result).to be_kind_of RShade::Trace
      result.show
      expect(formatter.events.count).to eq 1
    end
  end

  context "variable value" do
    let(:config) do
      base_config.match_variable do |name, value|
        value == 4
      end
    end

    let(:result) do
      RShade::Trace.reveal(config) do
        TestRshade3.call
      end
    end

    it "not match", focus: true do
      expect(result).to be_kind_of RShade::Trace
      result.show
      expect(formatter.events.count).to eq 0
    end
  end

  context "variable name" do
    let(:config) do
      base_config.match_variable do |name, value|
        name == :z
      end
    end

    let(:result) do
      RShade::Trace.reveal(config) do
        TestRshade3.call
      end
    end

    it "not match" do
      expect(result).to be_kind_of RShade::Trace
      result.show
      expect(formatter.events.count).to eq 0
    end
  end
end
