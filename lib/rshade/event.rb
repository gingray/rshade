module RShade
  # nodoc
  class Event
    attr_reader :hash, :skipped
    RETURN_EVENTS = [:return, :b_return, :c_return]


    def initialize(hash)
      @hash = hash
    end

    [:klass, :path, :lineno, :method_name, :vars, :level, :return_value].each do |method_name|
      define_method method_name do
        fetch method_name
      end
    end

    def with_level!(level)
      @hash[:level] = level
      self
    end

    def set_return_value!(return_value)
      @hash[:return_value] = return_value
      self
    end

    def with_serialized_return!(serializer)
      @hash[:return_value] = serializer.call(@hash[:return_value])
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
      hash.merge!({return_value: evt.return_value}) if RETURN_EVENTS.include?(evt.event)
      new(hash)
    end

    private

    def fetch(key)
      @hash[key]
    end
  end
end
