require 'set'

module RShade
  class Config
    attr_accessor :track_gems, :filter, :formatter

    def initialize
      @track_gems = Set.new
    end

    def self.default
      ::RShade::Config::Store.new(::RShade::Filter::Default.create, ::RShade::Formatter::Stdout)
    end

    def filter
      @filter ||= ::RShade::Filter::Default
    end

    def formatter
      @formatter ||= ::RShade::Formatter::Stdout
    end

    def store_dir
      File.expand_path('../../tmp', __dir__)
    end

    def root_dir
      @root_dir ||= File.expand_path('../../', __dir__)
    end
  end
end
