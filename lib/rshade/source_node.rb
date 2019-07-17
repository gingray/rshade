module RShade
  class SourceNode
    attr_accessor :nodes, :value, :parent

    def initialize(parent, value = nil)
      @nodes = []
      @value = value || { valid: true, level: 0 }
      @value[:valid] = true unless @value.has_key?(:valid)
      @parent = parent
    end

    def add(node)
      @nodes << node
    end

    def valid?
      @value[:valid]
    end

    def toggle_valid(state)
      @value[:valid] = state
    end

    def level
      @value[:level] || 0
    end

    def klass
      @value[:klass]
    end

    def method_name
      @value[:method_name]
    end

    def path
      @value[:path]
    end

    def lineno
      @value[:lineno]
    end

    def valid_parent(node = self)
      any_valid_node = node.parent.nodes.any? do |item|
        next false if item == node

        node.valid?
      end
      return node.parent if node.parent.valid? || any_valid_node || node.parent.nil?

      return valid_parent(node.parent) if node.parent
      nil
    end

    def copy
      SourceNode.new(nil, @value.dup)
    end

    def pretty
      class_method = "#{klass}##{method_name}".colorize(:green)
      full_path = "#{path}:#{lineno}".colorize(:blue)
      "#{class_method} -> #{full_path}"
    end

    def filter(node = self, &block)
      return unless block_given?

      node.nodes.each do |item|
        filter(item, &block)
      end

      unless yield(node)
        node.toggle_valid false
      end
    end

    def filter2(node = self, copy = SourceNode.new(nil), &block)
      return unless block_given?

      node.nodes.each do |item|
        node_copy = filter2(item, copy, &block)
        copy.add node_copy unless node_copy.nil?
      end

      return node.copy if yield(node)

      nil
    end

    def traverse(node = self, &block)
      return unless block_given?

      yield(node)
      node.nodes.each { |leaf| traverse(leaf, &block) }
    end
  end
end
