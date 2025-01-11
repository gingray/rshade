# frozen_string_literal: true

module RShade
  class Stack
    attr_reader :config

    def initialize(config: nil, registry: ::RShade::Config::Registry.instance)
      @config = config || registry.default_stack_config
    end

    def self.trace(config: nil)
      new(config: config).trace
    end

    def trace
      config.exclude_gems!
      result = binding.callers.drop(2).map do |bind|
        frame = StackFrame.from_binding(bind)
        next nil unless config.filter.call(frame)

        frame
      end.compact.reverse
      config.formatter.call(result, variable_serializer: config.variable_serializer)
    end
  end
end
