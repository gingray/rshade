RSpec.describe RShade::Config do
  context "check config creation" do
    let(:formatter) { double }
    let(:config) do
      RShade::Config.create.exclude_paths { |paths| paths << "123" }
                    .include_paths { |paths| paths << "321" }
                    .formatter { formatter }
                    .value
    end

    xit do
      filters = config.filter_composition.to_a
      expect(filters[0]).to be_a(::RShade::Filter::IncludePathFilter)
      expect(filters[1]).to be_a(::RShade::Filter::ExcludePathFilter)
      expect(config.formatter).to eq formatter
    end
  end

  context "check config creation with default values" do
    let(:config) { RShade::Config.create_with_default.value }

    xit do
      filters = config.filter_composition.to_a
      expect(filters[0]).to be_a(::RShade::Filter::ExcludePathFilter)
      expect(config.formatter).to be_a(::RShade::Formatter::Stdout)
    end
  end
end