module RShade
  # nodoc
  class Event
    attr_reader :hash
    attr_accessor :depth

    def initialize(hash)
      @hash = hash
    end

    def level
      @hash[:level]
    end

    def klass
      @hash[:klass]
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
  end
end
