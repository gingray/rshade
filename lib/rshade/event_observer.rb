module RShade
  class EventObserver
    attr_reader :event_store, :config

    def initialize(config)
      @event_store = EventStore.new
      @config = fetch_config(config)
      @level = 0
      @hook = Hash.new(0)
      @hook[:enter] = 1
      @hook[:leave] = -1
    end

    # @param [:enter, :leave, :other] type
    # @param [RShade::Event] event
    def call(event, type)
      @level += @hook[type]

      return unless pass?(event)

      event.with_level!(@level)
      enter(event) if type == :enter
      leave(event) if type == :leave
      other(event) if type == :other
    end

    def show
      config.formatter.call event_store
    end

    private

    def enter(event)
      event_store << event
    end

    def leave(event)
      event_store << event
    end

    def other(event)

    end

    def pass?(event)
      grouped_filters = config.filters.group_by { |filter| filter.name }
      return true if grouped_filters[::RShade::Filter::VariableFilter::NAME]&.any? { |filter| filter.call(event) }
      return true if grouped_filters[::RShade::Filter::IncludePathFilter::NAME]&.any? { |filter| filter.call(event) }
      return false if grouped_filters[::RShade::Filter::ExcludePathFilter::NAME]&.any? { |filter| filter.call(event) }

      true
    end

    def fetch_config(config)
      config = config || ::RShade::Config.default
      config = config.value if config.is_a?(::RShade::Config)
      config
    end
  end
end