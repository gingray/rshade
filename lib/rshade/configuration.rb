module RShade
  class Configuration
    RUBY_VERSION_PATTERN = /ruby-[0-9.]*/

    attr_accessor :track_gems, :filter, :formatter

    def initialize
      @track_gems = Set.new
    end

    def excluded_paths
      @excluded_paths ||= begin
        paths = [ENV['GEM_PATH'].split(':'), parse_ruby_version].flatten.compact
        paths.reject do |v|
          track_gems.any? { |gem_name| v.include? gem_name }
        end
      end
    end

    def parse_ruby_version
      val = RUBY_VERSION_PATTERN.match(ENV['GEM_PATH'])
      return nil unless val

      val[0]
    end

    def filter
      @filter ||= ::RShade::Filter::AppFilter
    end

    def formatter
      @formatter ||= ::RShade::Formatter::Stdout
    end
  end
end
