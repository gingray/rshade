module RShade
  class SourceValue
    attr_accessor :path, :level

    def initialize(level=nil, path=nil)
      @level = level
      @path = path
    end

    def inspect
      "level<#{level}> path[#{path}]"
    end
  end
end
