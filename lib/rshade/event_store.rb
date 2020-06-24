module RShade
  # nodoc
  class EventStore
    attr_reader :events

    def initialize
      @events = []
    end

    def <<(event)
      events << event
    end

    def iterate(&block)
      pos_map = {}
      @events.map {|item| item.level }.uniq.sort.each_with_index { |item, index| pos_map[item] = index}
      @events.uniq{|item| [item.level, "#{item.klass}##{item.method_name}"]}.sort_by { |item| item.depth }.each do |item|
        item.depth = pos_map[item.level]
        yield(item, item.depth)
      end
    end
  end
end
