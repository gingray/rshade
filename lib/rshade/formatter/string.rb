module RShade
  module Formatter
    class String < ::RShade::Base
      attr_reader :event_store
      ROOT_SEP = "---\n"

      def initialize(event_store)
        @event_store = event_store
      end

      def call
        buffer = StringIO.new
        event_store.iterate do |node, depth|
          if depth == 1
            buffer << ROOT_SEP
            next
          end
          puts line(node, depth)
        end
        buffer.string
      end

      def line(value, depth)
        class_method = "#{value.klass}##{value.method_name}".colorize(:green)
        full_path = "#{value.path}:#{value.lineno}".colorize(:blue)
        "#{'  ' * depth}#{class_method}() -> #{full_path}\n"
      end
    end
  end
end