module RShade
  # nodoc
  class Tree
    attr_accessor :parent, :value
    attr_reader :nodes

    def initialize(value = nil)
      @value = value
      @nodes = []
      @parent = nil
    end

    def root?
      !parent
    end

    def <<(node)
      @nodes << node
    end

    def pre_order_traverse(node = self, depth = 0, &block)
      return unless block_given?

      yield(node, depth)
      nodes.each do |item|
        pre_order_traverse(item, depth + 1, &block)
      end
    end

    def print_tree(buffer = StringIO.new, depth = 0)
      buffer << "+\n" if root?
      buffer << "#{depth * ''}#{value}\n"
      @nodes.each do |node|
        node.pretty_print(buffer, depth + 1)
      end
      buffer.string
    end
  end
end
