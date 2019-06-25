require "rshade/tree"
require "rshade/version"

module Rshade
  class Trace
    EVENTS = %i[call return].freeze

    def initialize
      @tree = Node.new(nil)
      @current_node = nil
      @tp = TracePoint.new(*EVENTS, &method(:process_trace))
    end

    def reveal
      return unless block_given?

      @tp.enable
      yield
      @tp.disable
    end

    def show(&block)
      return print_tree(@tree.copy(&block)) if block_given?

      print_tree(@tree)
    end

    def print_tree(root)
      str = StringIO.new
      Node.traverse(root) do |node, level|
        str.write"#{' ' * level} #{node.value}\n"
      end
      str.string
    end

    def process_trace(tp)
      @current_node ||= @tree
      if tp.event == :call
        node = Node.new(@current_node, tp.path)
        @current_node.nodes << node
        @current_node = node
      end

      @current_node = @current_node.parent if tp.event == :return
    end
  end
end
