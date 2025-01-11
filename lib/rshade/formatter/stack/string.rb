# frozen_string_literal: true

module RShade
  module Formatter
    module Stack
      class String
        attr_reader :colorize

        ROOT_SEP = "---\n"

        def initialize(colorize: true)
          @colorize = colorize
        end

        # @param [RShade::EventProcessor] stack_frames
        def call(stack_frames, variable_serializer: nil)
          buffer = StringIO.new
          stack_frames.each_with_index do |frame, idx|
            if idx.zero?
              buffer << ROOT_SEP
              next
            end
            next unless frame

            buffer.write line(idx, frame, idx)
          end
          buffer.string
        end

        private

        # @param [RShade::StackFrame] frame
        def line(line_idx, frame, depth)
          source_location = apply_color("(#{frame.source_location[:path]}:#{frame.source_location[:line]})", :green)
          var_str = frame.local_vars.map do |_, val|
            var_name = val[:name]
            var_value = val[:value]
            var_type = val[:type]
            "#{var_type} #{var_name} => (#{var_value})"
          end.join(', ')
          colorized_var_str = apply_color(var_str, :blue)
          "#{'  ' * depth}[frame: #{line_idx}]#{source_location} => local vars: (#{colorized_var_str})\n"
        end

        def apply_color(str, color)
          return str unless colorize

          ColorizedString[str].colorize(color)
        end
      end
    end
  end
end
