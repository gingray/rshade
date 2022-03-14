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

    def self.from_trace_point(evt)
      vars = {}
      evt.binding.local_variables.each do |var_name|
        vars[var_name] = evt.binding.local_variable_get var_name
      end

      hash = { path: evt.path, lineno: evt.lineno, klass: evt.defined_class, method_name: evt.method_id, vars: vars,
               event_type: evt.event }
      new(hash)
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
