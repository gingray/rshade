module RShade
  class Trace
    attr_accessor :event_store, :formatter, :filter
    EVENTS = %i[call return].freeze

    def initialize(options={})
      @event_store = EventStore.new
      @formatter = options.fetch(:formatter, RShade.config.formatter)
      @filter = options.fetch(:filter, RShade.config.filter)
      @tp = TracePoint.new(*EVENTS, &method(:process_trace))
      @level = 1
      @stat = {}
      @calls = 0
      @returns = 0
    end

    def self.reveal(options={}, &block)
      new(options).reveal(&block)
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
      formatter.call(event_store)
    end

    def stat
      { calls: @calls, returns: @returns }
    end

    def process_trace(tp)
      if tp.event == :call
        @level +=1
        hash = EventSerializer.call(tp, @level)
        return unless filter.call(hash)
        @calls += 1
        event_store << Event.new(hash)
      end

      if tp.event == :return && @level > 0
        @returns += 1
        @level -=1
      end
    end
  end
end
