module RShade
  class Trace
    attr_accessor :event_store, :config
    EVENTS = %i[call return].freeze

    def initialize(config)
      @event_store = EventStore.new
      @config = fetch_config(config)
      @tp = TracePoint.new(*EVENTS, &method(:process_trace))
      @level = 0
      @stat = {}
      @calls = 0
      @returns = 0
    end

    def self.reveal(config=nil, &block)
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
      grouped_filters = config.filters.group_by { |filter| filter.name }
      return true if grouped_filters[::RShade::Filter::IncludePathFilter::NAME]&.any? { |filter| filter.call(event) }
      return false if grouped_filters[::RShade::Filter::ExcludePathFilter::NAME]&.any? { |filter| filter.call(event) }

      true
    end

    private

    def fetch_config(config)
      config = config || ::RShade::Config.default
      config = config.value if config.is_a?(::RShade::Config)
      config
    end
  end
end
