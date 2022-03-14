module RShade
  module Filter
    class ExcludePathFilter < IncludePathFilter
      NAME = :exclude_paths

      def name
        NAME
      end

      def priority
        0
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