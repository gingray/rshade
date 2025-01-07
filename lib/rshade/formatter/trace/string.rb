# frozen_string_literal: true

module RShade
  module Formatter
    module Trace
      class String
        ROOT_SEP = "---\n"

        def initialize(opts = {}); end

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
          returned_value = value.return_value || {}
          returned_str = "#{returned_value[:type]} #{returned_value[:value]}"
          returned = ColorizedString["=> |#{returned_str}|"].colorize(:magenta)

          class_method = ColorizedString["#{value.klass}##{value.method_name}"].colorize(:green)
          full_path = ColorizedString["#{value.path}:#{value.lineno}"].colorize(:blue)
          line_idx = ColorizedString["[#{line_idx}] "].colorize(:red)
          var_str = vars.map do |_, val|
            var_name = val[:name]
            var_value = val[:value]
            var_type = val[:type]
            "#{var_type} #{var_name} => (#{var_value})"
          end.join(', ')
          "#{'  ' * depth}#{line_idx}#{class_method}(#{var_str}) #{returned} -> #{full_path}\n"
        end
      end
    end
  end
end
