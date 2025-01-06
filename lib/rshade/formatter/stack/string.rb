# frozen_string_literal: true

module RShade
  module Formatter
    module Stack
      class String
        ROOT_SEP = "---\n"

        def initialize(opts = {}); end

        # @param [RShade::EventProcessor] stack
        def call(stack)
          buffer = StringIO.new
          stack.each_with_index do |frame, idx|
            if idx == 0
              buffer << ROOT_SEP
              next
            end
            next unless frame

            buffer.write line(idx, frame, idx)
          end
          buffer.string
        end

        # @param [RShade::StackFrame] frame
        def line(line_idx, frame, depth)
          source_location = ColorizedString["(#{frame.source_location[:path]}:#{frame.source_location[:line]})"].colorize(:green)
          var_str = frame.local_vars.map do |_, val|
            var_name = val[:name]
            var_value = val[:value]
            var_type = val[:type]
            "#{var_type} #{var_name} => (#{var_value})"
          end.join(', ')
          colorized_var_str = ColorizedString[var_str].colorize(:blue)
          "#{'  ' * depth}[frame: #{line_idx}]#{source_location} => local vars: (#{colorized_var_str})\n"
        end
      end
    end
  end
end
