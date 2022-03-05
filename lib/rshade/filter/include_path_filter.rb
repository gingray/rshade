module RShade
  module Filter
    class IncludePathFilter < Base
      attr_reader :paths
      def initialize
        @paths = []
      end

      def name
        :include_paths
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