module RShade
  # nodoc
  class SourceNode < Tree
    def initialize(value = nil)
      super(value)
    end

    def clone_by(new_tree = SourceNode.new(nil), &block)
      if yield(self)
        new_tree.value = value
        node = SourceNode.new(nil)
        node.parent = new_tree
        new_tree << node
        new_tree = node
      end

      nodes.each do |item|
        item.clone_by(new_tree, &block)
      end
      new_tree
    end
  end
end
