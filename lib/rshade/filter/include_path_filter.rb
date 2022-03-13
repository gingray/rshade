module RShade
  module AbstractFilter
    class IncludePathFilter < Base
      attr_reader :paths

      NAME = :include_paths

      def initialize
        @paths = []
      end

      def name
        NAME
      end

      def priority
        1
      end

      def call(event)
        event_path = event.path
        paths.any? do |path|
          next str?(path, event_path) if path.is_a? String
          next regexp?(path, event_path) if path.is_a? Regexp
          false
        end
      end

      def config_call(&block)
        block.call(@paths)
      end

      private
      def str?(str, event_path)
        event_path.include?(str)
      end

      def regexp?(regex, event_path)
        regex.match?(event_path)
      end
    end
  end
end