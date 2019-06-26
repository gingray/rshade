module RShade
  class SourceValue
    attr_accessor :hash, :level, :lineno

    def initialize(hash = {})
      @hash = hash
    end

    def inspect
      class_method = "#{@hash[:klass]}##{@hash[:method]}".colorize(:green)
      path = "#{@hash[:path]}:#{@hash[:lineno]}".colorize(:blue)
      "#{class_method} -> #{path}"
    end
  end
end
