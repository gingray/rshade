module RShade
  # nodoc
  class EventStore
    attr_reader :current, :head

    def initialize
      @current = EventStoreNode.new(0)
      @head = @current
    end

    def <<(event)
      if current.level + 1 == event.level
        current.children << EventStoreNode.new(event, current)
        return
      end
      if current.level + 1 < event.level
        @current = current.children.last
        self.<<(event)
        return
      end
      if current.level + 1 > event.level
        return unless current.parent
        @current = current.parent
        self.<<(event)
        return
      end
    end
  end

  class EventStoreNode
    include Enumerable
    attr_reader :children, :level, :event
    attr_accessor :parent

    def initialize(event, parent=nil)
      @children = []
      unless parent
        @level = 0
        return
      end

      @level = event.level
      @event = event
    end

    def each(&block)
      block.call(self) if @level > 0
      children.each { |item| item.each(&block) }
    end
  end
end
