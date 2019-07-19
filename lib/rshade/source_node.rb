module RShade
  # nodoc
  class SourceNode < Tree
    attr_accessor :nodes, :value, :parent

    def initialize(value = nil)
      super(value)
    end

    def traverse(node = self, &block)
      return unless block_given?

      yield(node)
      node.nodes.each { |leaf| traverse(leaf, &block) }
    end
  end
end
