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
      return true if RShade.configuration.included_gems.any? { |item| path.include? item }

      @app_code ||= RShade.configuration.excluded_paths.none? { |item| path.include? item }
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

    def vars
      @hash[:vars]
    end


    def pretty
      class_method = "#{klass}##{method_name}".colorize(:green)
      full_path = "#{path}:#{lineno}".colorize(:blue)
      "#{class_method}(#{vars.to_json}) -> #{full_path}"
    end
  end
end
