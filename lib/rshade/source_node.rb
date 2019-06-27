module RShade
  class SourceNode
    attr_accessor :nodes, :value, :parent
    MAX_SIZE = 5

    def initialize(parent, value=nil)
      @nodes = []
      @value = value
      @parent = parent
    end

    def add(node)
      @nodes << node
    end

    def print_tree
      str = StringIO.new
      traverse(self) do |node|
        str.write"#{' ' * node.value.level}#{node.value.inspect}\n" if node.value.valid
      end
      str.string
    end

    def filter(node = self, &block)
      return unless block_given?

      node.nodes.each do |item|
        filter(item, &block)
      end

      unless yield(node)
        node.value.valid = false
      end
    end

    def traverse(node, &block)
      return unless block_given?

      yield(node)
      node.nodes.each { |leaf| traverse(leaf, &block) }
    end
  end
end
