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
        event_store.each do |node|
          depth = node.level
          event = node.event
          if depth == 1
            buffer << ROOT_SEP
            next
          end
          next if @ignore_skipped && event.skipped
          buffer.write line(event, depth)
        end
        buffer.string
      end

      def line(value, depth)
        class_method = ColorizedString["#{value.klass}##{value.method_name}"].colorize(:green)
        full_path = ColorizedString["#{value.path}:#{value.lineno}"].colorize(:blue)
        "#{'  ' * depth}#{class_method}(#{value.vars}) -> #{full_path}\n"
      end
    end
  end
end