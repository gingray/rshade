module RShade
  module Formatter
    class String < ::RShade::Base
      attr_reader :origin_tree
      ROOT_SEP = "---\n"

      def initialize(origin_tree)
        @origin_tree = origin_tree
      end

      def call
        buffer = StringIO.new
        origin_tree.pre_order_traverse do |node, depth|
          next if depth > 50
          if node.root?
            buffer << ROOT_SEP
            next
          end

          buffer << line(node.value, depth) if node.value
        en  d
        buffer
      end

      def line(value, depth)
        class_method = "#{value.klass}##{value.method_name}".colorize(:green)
        full_path = "#{value.path}:#{value.lineno}".colorize(:blue)
        "#{'  ' * depth} #{class_method}(#{value.vars.to_json}) -> #{full_path}\n"
      end
    end
  end
end