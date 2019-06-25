module RShade
  class SourceNode
    attr_accessor :nodes, :value, :parent

    def initialize(parent, value=nil)
      @nodes = []
      @value = value
      @parent = parent
    end

    def add(node)
      @nodes << node
    end

    def duplicate(parent=nil, &block)
      node = SourceNode.new(parent)
      if block_given?
        nodes.select(&block).each do |item|
          node.nodes << item.duplicate(node)
        end
      else
        nodes.each do |item|
          node.nodes << item.duplicate(node)
        end
      end
      node
    end

    def print_tree
      str = StringIO.new
      traverse(self) do |node|
        str.write"#{' ' * node.value.level} #{node.value.path}\n"
      end
      str.string
    end

    def traverse(node, &block)
      return unless block_given?

      block.call(node, level)
      node.nodes.each { |leaf| traverse(leaf, &block) }
    end
  end
end
