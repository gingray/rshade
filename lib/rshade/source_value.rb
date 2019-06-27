module RShade
  class SourceValue
    attr_accessor :hash, :lineno

    def initialize(hash = {})
      @hash = hash
    end

    def inspect
      class_method = "#{@hash[:klass]}##{@hash[:method]}".colorize(:green)
      path = "#{@hash[:path]}:#{@hash[:lineno]}".colorize(:blue)
      "#{class_method} -> #{path}"
    end

    def level
      hash[:level]
    end

    def path
      hash[:path]
    end
  end
end
