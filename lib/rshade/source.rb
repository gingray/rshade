module RShade
  # nodoc
  class Source
    def initialize(hash)
      @hash = hash
    end

    def klass
      @hash[:klass]
    end

    def lib_code?
      !app_code?
    end

    def app_code?
      @app_code ||= exclude_path.none? { |item| path.include? item }
    end

    def path
      @hash[:path]
    end

    def lineno
      @hash[:lineno]
    end

    def method_name
      @hash[:method_name]
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

    def pretty
      class_method = "#{klass}##{method_name}".colorize(:green)
      full_path = "#{path}:#{lineno}".colorize(:blue)
      "#{class_method} -> #{full_path}"
    end
  end
end
