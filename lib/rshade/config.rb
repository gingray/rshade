module RShade
  class Config

    def self.default
      ::RShade::Config::Store.create(::RShade::AbstractFilter::Default.create, ::RShade::Formatter::Stdout.new)
    end

    # @param [RShade::Config::Store] config_store
    def initialize(config_store)
      @config_store = config_store
    end

    def self.create
      new(Config::Store.new)
    end

    def self.create_with_default
      new(::RShade::Config::Store.create(::RShade::AbstractFilter::Default.create, ::RShade::Formatter::Stdout.new))
    end

    def include_paths(&block)
      filter = ::RShade::AbstractFilter::IncludePathFilter.new
      filter.config(&block)
      @config_store.add_filter(filter)
      self
    end

    def exclude_paths(&block)
      filter = ::RShade::AbstractFilter::ExcludePathFilter.new
      filter.config(&block)
      @config_store.add_filter(filter)
      self
    end

    def match_variable(&block)
      filter = ::RShade::AbstractFilter::VariableFilter.new
      filter.config(&block)
      @config_store.add_filter(filter)
      self
    end

    def formatter(&block)
      formatter = block.call
      @config_store.set_formatter(formatter)
      self
    end

    def value
      @config_store
    end

    def self.store_dir
      File.expand_path('../../tmp', __dir__)
    end

    def self.root_dir
      @root_dir ||= File.expand_path('../../', __dir__)
    end
  end
end
