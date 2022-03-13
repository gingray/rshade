module RShade
  module Formatter
    class String < ::RShade::Base
      attr_reader :event_store
      ROOT_SEP = "---\n"

      def initialize(event_store, opts= {})
        @event_store = event_store
        @ignore_skipped = opts.fetch(:ignore_skipped, true)
      end

      def call
        buffer = StringIO.new
        event_store.each_with_index do |node, idx|
          depth = node.level
          event = node.event
          if depth == 1
            buffer << ROOT_SEP
            next
          end
          next if @ignore_skipped && event.skipped
          buffer.write line(idx, event, node.vlevel)
        end
        buffer.string
      end

      def line(line_idx, value, depth)
        vars = value.vars.map { |key, val| [key, val[:copy]]}.to_h
        class_method = ColorizedString["#{value.klass}##{value.method_name}"].colorize(:green)
        full_path = ColorizedString["#{value.path}:#{value.lineno}"].colorize(:blue)
        line_idx = ColorizedString["[#{line_idx}] "].colorize(:red)
        "#{'  ' * depth}#{line_idx}#{class_method}(#{vars}) -> #{full_path}\n"
      end
    end
  end
end