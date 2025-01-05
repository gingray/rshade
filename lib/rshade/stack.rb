# frozen_string_literal: true

module RShade
  class Stack
    def self.trace(_config = nil)
      new.trace
    end

    def trace
      filter = RShade::Filter::ExcludePathFilter.new.config do |paths|
        paths.concat(RShade::Config.default_excluded_path)
      end

      result = binding.callers.drop(2).map do |bind|
        frame = StackFrame.from_binding(bind)
        next nil unless filter.call(frame)

        frame
      end.compact.reverse
      puts result
    end
  end
end
