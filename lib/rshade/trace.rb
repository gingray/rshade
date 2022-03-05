module RShade
  class Trace
    attr_accessor :event_store, :config
    EVENTS = %i[call return].freeze

    def initialize(config)
      @event_store = EventStore.new
      @config = config
      @tp = TracePoint.new(*EVENTS, &method(:process_trace))
      @level = 0
      @stat = {}
      @calls = 0
      @returns = 0
    end

    def self.reveal(config=nil, &block)
      config = config || ::RShade::Config.default
      new(config).reveal(&block)
    end

    def reveal
      return unless block_given?

      @tp.enable
      yield
      self
    ensure
      @tp.disable
    end

    def show
      config.formatter.new(event_store).call
    end

    def stat
      { calls: @calls, returns: @returns }
    end

    def process_trace(tp)
      if tp.event == :call
        @level += 1
        event = EventSerializer.call(tp, @level)
        return unless pass?(event)
        event_store << event
        @calls += 1
      end

      if tp.event == :return && @level > 0
        @returns += 1
        @level -= 1
      end
    end

    def pass?(event)
      config.filters.any? { |filter| filter.call(event) }
    end
  end
end
