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

    def traverse(node = self, &block)
      return unless block_given?

      yield(node)
      node.nodes.each { |leaf| traverse(leaf, &block) }
    end
  end
end
