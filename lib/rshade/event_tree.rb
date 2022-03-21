module RShade
  class EventTree
    include Enumerable

    attr_reader :current, :head

    def initialize
      @current = @head = EventTreeNode.new(nil, 0, nil)
    end

    def add(value, level)
      if current.level + 1 == level
        current.children << EventTreeNode.new(value, level, current)
        return
      end
      if current.level + 1 < level

        last = current.children.last
        unless last
          current.children << EventTreeNode.new(nil, current.level + 1 , current)
        end
        @current = current.children.last
        add(value, level)
        return
      end

      if current.level + 1 > level
        unless current.parent
          return
        end
        @current = current.parent
        add(value, level)
      end
    end

    def current!(&block)
      block.call(current.children.last) if current.children.last
    end

    def each(&block)
      @head.each(&block)
    end
  end

  class EventTreeNode
    include Enumerable
    attr_reader :children, :level, :vlevel, :value
    attr_accessor :parent

    def initialize(value, level, parent=nil)
      @children = []
      @level = level
      @parent = parent
      @value = value
      @vlevel = set_vlevel(parent)
    end

    def each(&block)
      block.call(self) if parent != nil || value != nil
      children.each { |item| item.each(&block) }
    end

    private

    def set_vlevel(node)
      return 0 if node == nil

      if node.value || node.level == 0
        node.vlevel + 1
      else
        set_vlevel(node.parent)
      end
    end
  end
end