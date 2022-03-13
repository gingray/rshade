RSpec.describe RShade::Config do
  context "check config creation" do
    let(:formatter) { double }
    let(:config) do
      RShade::Config.create.exclude_paths { |paths| paths << "123" }
                    .include_paths { |paths| paths << "321" }
                    .formatter { formatter }
                    .value
    end

    it do
      expect(config.filters[0]).to be_a(::RShade::AbstractFilter::IncludePathFilter)
      expect(config.filters[1]).to be_a(::RShade::AbstractFilter::ExcludePathFilter)
      expect(config.formatter).to eq formatter
    end
  end

  context "check config creation with default values" do
    let(:config) { RShade::Config.create_with_default.value }

    it do
      expect(config.filters[0]).to be_a(::RShade::AbstractFilter::ExcludePathFilter)
      expect(config.formatter).to be_a(::RShade::Formatter::Stdout)
    end
  end
end