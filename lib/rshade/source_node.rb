module RShade
  class SourceNode
    attr_accessor :nodes, :value, :parent
    MAX_SIZE = 5

    def initialize(parent, value=nil)
      @nodes = Set.new
      @value = value
      @parent = parent
    end

    def add(node)
      @nodes << node
    end

    def eql?(other)
      value?.path == other.value?.path
    end

    def print_tree
      str = StringIO.new
      traverse(self) do |node|
        str.write"#{' ' * node.value.level}#{node.value.inspect}\n"
      end
      str.string
    end

    def traverse(node, &block)
      return unless block_given?

      block.call(node)
      node.nodes.each { |leaf| traverse(leaf, &block) }
    end
  end
end
