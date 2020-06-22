module RShade
  module Filter
    class AppFilter < ::RShade::Base
      attr_reader :origin_tree

      def initialize(origin_tree)
        @origin_tree = origin_tree
      end

      def call
        origin_tree.clone_by do |node|
          next true if node.root?
          next false unless node.value
          valid?(node.value.path)
        end
      end

      def valid?(path)
        return true if RShade.configuration.track_gems.any? { |item| path.include? item }
        RShade.configuration.excluded_paths.none? { |item| path.include? item }
      end
    end
  end
end