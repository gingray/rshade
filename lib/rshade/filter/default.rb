# frozen_string_literal: true

module RShade
  module Filter
    class Default
      RUBY_VERSION_PATTERN = /ruby-[0-9.]*/.freeze

      def self.create
        new.create
      end

      def create
        [create_exclude]
      end

      def create_exclude
        filter = ExcludePathFilter.new
        filter.config do |paths|
          excluded_paths.each do |path|
            paths << path
          end
        end
      end

      def excluded_paths
        [ENV['GEM_PATH'].split(':'), RUBY_VERSION_PATTERN, /internal/].flatten.compact
      end
    end
  end
end
