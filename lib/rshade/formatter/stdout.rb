module RShade
  module Formatter
    class Stdout < ::RShade::Base
      attr_reader :origin_tree
      ROOT_SEP = "---\n"

      def initialize(origin_tree)
        @origin_tree = origin_tree
      end

      def call
        buffer = StringIO.new
        origin_tree.pre_order_traverse do |node, depth|
          if node.root?
            buffer << ROOT_SEP
            next
          end

          buffer << line(node, depth) if node.value
        end
        puts buffer.string
      end

      def line(node, depth)
        class_method = "#{node.klass}##{node.method_name}".colorize(:green)
        full_path = "#{node.path}:#{node.lineno}".colorize(:blue)
        "#{'  ' * depth} #{class_method}(#{node.vars.to_json}) -> #{full_path}\n"
      end
    end
  end
end