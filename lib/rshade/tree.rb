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

    def pre_order_traverse(depth = 0, &block)
      return unless block_given?

      yield(self, depth)
      nodes.each do |item|
        item.pre_order_traverse(depth + 1, &block)
      end
    end
  end
end
