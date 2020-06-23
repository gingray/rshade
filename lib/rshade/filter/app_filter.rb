module RShade
  module Filter
    class AppFilter < ::RShade::Base
      attr_reader :data

      def initialize(data)
        @data = data
      end

      def call
        valid?(data[:path])
      end

      def valid?(path)
        return true if RShade.config.track_gems.any? { |item| path.include? item }
        RShade.config.excluded_paths.none? { |item| path.include? item }
      end
    end
  end
end