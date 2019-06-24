module Rshade
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

    def to_s
      str = StringIO.new
      Node.traverse(self) do |node, level|
        str.write"#{'' * level} #{node.value}\n"
      end
      str.string
    end

    def self.traverse(node, level = 0, &block)
      return unless block_given?

      block.call(node, level)
      node.nodes.each { |leaf| traverse(leaf, level + 1, &block) }
    end

  end
end
