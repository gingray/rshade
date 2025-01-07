# frozen_string_literal: true

module RShade
  # nodoc
  class Event
    attr_reader :hash, :skipped

    RETURN_EVENTS = %i[return b_return c_return].freeze

    def initialize(hash)
      @hash = hash
    end

    %i[klass path lineno method_name vars level return_value].each do |method_name|
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
        local_val = evt.binding.local_variable_get(var_name)
        local_val_type = local_val.is_a?(Class) ? local_val : local_val.class
        hash = { name: var_name, value: local_val, type: local_val_type }
        vars[var_name] = hash
      end

      hash = { path: evt.path, lineno: evt.lineno, klass: evt.defined_class, method_name: evt.method_id, vars:,
               event_type: evt.event }

      if RETURN_EVENTS.include?(evt.event)
        ret_val = evt.return_value
        ret_val_type  = evt.return_value.is_a?(Class) ? evt.return_value : evt.return_value.class
        hash.merge!({ return_value: { value: ret_val, type: ret_val_type } })
      end
      new(hash)
    end

    private

    def fetch(key)
      @hash[key]
    end
  end
end
