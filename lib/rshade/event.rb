module RShade
  # nodoc
  class Event
    attr_reader :hash, :skipped


    def initialize(hash, skipped=false)
      @hash = hash
      @skipped = skipped
    end

    [:klass, :path, :lineno, :method_name, :vars, :level].each do |method_name|
      define_method method_name do
        fetch method_name
      end
    end

    def with_level!(level)
      @hash[:level] = level
      self
    end

    def with_serialized_vars!(serializer)
      @hash[:vars] = serializer.call(@hash[:vars])
      self
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
