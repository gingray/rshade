module RShade
  class Filter
    RUBY_VERSION_PATTERN = /ruby-[0-9.]*/
    def call(path)
      exclude_path.none? { |item| path.include? item }
    end

    def exclude_path
      @path_arr ||= begin
        [ENV['GEM_PATH'].split(':'), parse_ruby_version].flatten.compact
      end
    end

    def parse_ruby_version
      val = RUBY_VERSION_PATTERN.match(ENV['GEM_PATH'])
      return nil unless val

      val[0]
    end
  end
end
