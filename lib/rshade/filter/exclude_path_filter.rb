# frozen_string_literal: true

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

      def call(event)
        event_path = event.path
        paths.none? do |path|
          next str?(path, event_path) if path.is_a? String
          next regexp?(path, event_path) if path.is_a? Regexp

          false
        end
      end
    end
  end
end
