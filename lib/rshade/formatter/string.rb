module RShade
  module Formatter
    class String
      ROOT_SEP = "---\n"

      def initialize(opts= {})
      end

      # @param [RShade::EventProcessor] event_store
      def call(event_store)
        buffer = StringIO.new
        event_store.each_with_index do |node, idx|
          depth = node.level
          event = node.value
          if depth == 1
            buffer << ROOT_SEP
            next
          end
          next unless event
          buffer.write line(idx, event, node.vlevel)
        end
        buffer.string
      end

      def line(line_idx, value, depth)
        vars = value.vars
        returned = ColorizedString["=> |#{value.return_value}|"].colorize(:magenta)

        class_method = ColorizedString["#{value.klass}##{value.method_name}"].colorize(:green)
        full_path = ColorizedString["#{value.path}:#{value.lineno}"].colorize(:blue)
        line_idx = ColorizedString["[#{line_idx}] "].colorize(:red)
        "#{'  ' * depth}#{line_idx}#{class_method}(#{vars}) #{returned} -> #{full_path}\n"
      end
    end
  end
end