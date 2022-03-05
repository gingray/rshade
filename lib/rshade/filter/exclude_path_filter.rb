module RShade
  module Filter
    class ExcludePathFilter < IncludePathFilter

      def name
        :exclude_paths
      end

      def priority
        0
      end

      private
      def str?(str, event_path)
        !event_path.include?(str)
      end

      def regexp?(regex, event_path)
        !regex.match?(event_path)
      end
    end
  end
end