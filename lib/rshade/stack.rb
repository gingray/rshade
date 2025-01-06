# frozen_string_literal: true

module RShade
  class Stack
    attr_reader :config

    def initialize(config: ::RShade::Config::StackStore.new)
      @config = config
    end

    def self.trace(config: ::RShade::Config::StackStore.new)
      new(config:).trace
    end

    def trace
      config.exclude_gems!
      result = binding.callers.drop(2).map do |bind|
        frame = StackFrame.from_binding(bind)
        next nil unless config.filter.call(frame)

        frame
      end.compact.reverse
      puts result
    end
  end
end
