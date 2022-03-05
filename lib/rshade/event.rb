module RShade
  # nodoc
  class Event
    attr_reader :hash, :skipped
    attr_accessor :depth


    def initialize(hash, skipped=false)
      @hash = hash
      @skipped = skipped
    end

    def level
      @hash[:level]
    end

    def klass
      fetch :klass
    end

    def path
      fetch :path
    end

    def lineno
      fetch :lineno
    end

    def method_name
      fetch :method_name
    end

    def vars
      fetch :vars
    end

    def self.create_blank(level)
      new({level: level}, true)
    end

    private

    def fetch(key)
      @hash[key] || "<skipped>"
    end
  end
end
