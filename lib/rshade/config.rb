# frozen_string_literal: true

module RShade
  class Config
    RUBY_VERSION_PATTERN = /ruby-[0-9.]*/.freeze

    def self.default
      ::RShade::Config::Store.new.formatter!(::RShade::Formatter::Trace::Stdout.new)
                             .config_filter(::RShade::Filter::ExcludePathFilter) do |paths|
        default_excluded_path.each do |path|
          paths << path
        end
      end
    end

    # @param [RShade::Config::Store] config_store
    def initialize(config_store)
      @config_store = config_store
    end

    # @param [Hash] options
    # @option options [RShade::Filter::FilterComposition] :filter_composition
    # @option options [#call(event_store)] :formatter
    # @option options [Array<Symbol>] :tp_events
    def self.create(options = {})
      new(Config::Store.new(options))
    end

    def tp_events(&block)
      events = block.call
      @config_store.tp_events!(events)
      self
    end

    def include_paths(&block)
      @config_store.config_filter(::RShade::Filter::IncludePathFilter, &block)
      self
    end

    def exclude_paths(&block)
      @config_store.config_filter(::RShade::Filter::ExcludePathFilter, &block)
      self
    end

    def match_variable(&block)
      @config_store.config_filter(::RShade::Filter::VariableFilter, &block)
      self
    end

    def formatter(&block)
      formatter = block.call
      @config_store.formatter!(formatter)
      self
    end

    def add_custom_serializers(hash)
      @config_store.add_custom_serializers(hash)
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

    def self.default_excluded_path
      [ENV['GEM_PATH'].split(':'), RUBY_VERSION_PATTERN, /internal/, %r{/gems/}].flatten.compact
    end
  end
end
