# frozen_string_literal: true

module RShade
  # nodoc
  class StackFrame
    attr_reader :hash

    def initialize(hash)
      @hash = hash
    end

    %i[source_location source local_vars receiver_variables].each do |method_name|
      define_method method_name do
        fetch method_name
      end
    end

    def path
      source_location[:path]
    end

    # @param [Binding] binding_frame
    def self.from_binding(binding_frame)
      source_location = {
        path: binding_frame.source_location[0],
        line: binding_frame.source_location[1]
      }
      local_vars = binding_frame.local_variables.each_with_object({}) do |var_name, memo|
        value = binding_frame.local_variable_get(var_name)
        type = value.is_a?(Class) ? value : value.class
        memo[var_name] = {
          name: var_name,
          value: value,
          type: type.to_s
        }
      end
      receiver_variables = binding_frame.receiver.instance_variables.each_with_object({}) do |var_name, memo|
        value = binding_frame.receiver.instance_variable_get(var_name)
        type = value.is_a?(Class) ? value : value.class
        memo[var_name] = {
          name: var_name,
          value: value,
          type: type.to_s
        }
      end
      hash = { source_location: source_location, local_vars: local_vars, source: {},
               receiver_variables: receiver_variables }
      new(hash)
    end

    def to_s
      "#{source_location} - #{local_vars} - #{source}"
    end

    private

    def fetch(key)
      @hash[key]
    end
  end
end
