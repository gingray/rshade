module RShade
  # nodoc
  class EventStore
    include Enumerable

    attr_reader :current, :head

    def initialize
      @current = EventStoreNode.new(Event.create_blank(0))
      @head = @current
    end

    def <<(event)
      if current.level + 1 == event.level
        current.children << EventStoreNode.new(event, current)
        return
      end
      if current.level + 1 < event.level

        last = current.children.last
        unless last
          current.children << EventStoreNode.new(Event.create_blank(current.level + 1), current)
        end
        @current = current.children.last
        self.<<(event)
        return
      end

      if current.level + 1 > event.level
        unless current.parent
          return
        end
        @current = current.parent
        self.<<(event)
        return
      end
    end

    def each(&block)
      head.each(&block)
    end
  end

  class EventStoreNode
    include Enumerable
    attr_reader :children, :level, :event
    attr_accessor :parent

    def initialize(event, parent=nil)
      @children = []
      @level = event.level
      @event = event
      @parent = parent
    end

    def each(&block)
      block.call(self) if @level > 0
      children.each { |item| item.each(&block) }
    end
  end
end
