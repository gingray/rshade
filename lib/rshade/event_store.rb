module RShade
  # nodoc
  class EventStore
    attr_reader :events, :current, :head

    def initialize
      @events = []
      @current = EventStoreElement.new(0)
      @head = @current
    end

    def <<(event)
      if event.level == current.level
        current.elements << event
        return
      end
      if current.level < event.level
        current._next = EventStoreElement.new(current.level + 1, self) unless current._next
        @current = current._next
        binding.pry
        self.<<(event)
        return
      end
      if current.level > event.level
        binding.pry
        return unless current.parent
        @current = current.parent
        self.<<(event)
        return
      end
    end

    def iterate(&block)
      head.elements.each do |item|
        block.call(item)
      end
    end
  end

  class EventStoreElement
    attr_reader :elements, :level
    attr_accessor :_next, :parent

    def initialize(level, parent=nil)
      @level = level
      @elements = []
      @_next = nil
    end
  end
end
