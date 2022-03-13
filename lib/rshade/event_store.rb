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
      end
    end

    def each(&block)
      head.each(&block)
    end
  end

  class EventStoreNode
    include Enumerable
    attr_reader :children, :level, :event, :vlevel
    attr_accessor :parent

    def initialize(event, parent=nil)
      @children = []
      @level = event.level
      @event = event
      @parent = parent
      @vlevel = set_vlevel(parent)
    end

    def set_vlevel(parent)
      return 0 if parent == nil

      if !parent.event.skipped || parent.level == 0
        parent.vlevel + 1
      else
        set_vlevel(parent.parent)
      end
    end

    def each(&block)
      block.call(self) if @level > 0
      children.each { |item| item.each(&block) }
    end
  end
end
