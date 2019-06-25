module RShade
  class Node
    attr_accessor :nodes, :value, :parent

    def initialize(parent, value=nil)
      @nodes = []
      @value = value
      @parent = parent
    end

    def add(node)
      @nodes << node
    end

    def copy(parent=nil, &block)
      node = Node.new(parent)
      if block_given?
        nodes.select(&block).each do |item|
          node.nodes << item.copy(node)
        end
      else
        nodes.each do |item|
          node.nodes << item.copy(node)
        end
      end
      node
    end

    def self.traverse(node, level = 0, &block)
      return unless block_given?

      block.call(node, level)
      node.nodes.each { |leaf| traverse(leaf, level + 1, &block) }
    end
  end
end
