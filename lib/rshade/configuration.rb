module RShade
  class Configuration
    RUBY_VERSION_PATTERN = /ruby-[0-9.]*/

    attr_accessor :custom_arg_print, :included_gems

    def initialize
      @included_gems = Set.new
    end

    def default_arg_print(args)

    end

    def excluded_paths
      @excluded_paths ||= begin
        paths = [ENV['GEM_PATH'].split(':'), parse_ruby_version].flatten.compact
        paths.reject do |v|
          included_gems.any? { |gem_name| v.include? gem_name }
        end
      end
    end

    def parse_ruby_version
      val = RUBY_VERSION_PATTERN.match(ENV['GEM_PATH'])
      return nil unless val

      val[0]
    end

  end
end
