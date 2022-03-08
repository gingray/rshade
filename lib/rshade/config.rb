module RShade
  class Config

    def self.default
      ::RShade::Config::Store.create(::RShade::Filter::Default.create, ::RShade::Formatter::Stdout)
    end

    def initialize(config_store)
      @config_store = config_store
    end

    def self.create
      new(Config::Store.new)
    end

    def self.create_with_default
      new(::RShade::Config::Store.create(::RShade::Filter::Default.create, ::RShade::Formatter::Stdout))
    end

    def include_paths(&block)
      filter = ::RShade::Filter::IncludePathFilter.new
      filter.config(&block)
      @config_store.add_filter(filter)
      self
    end

    def exclude_paths(&block)
      filter = ::RShade::Filter::ExcludePathFilter.new
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
