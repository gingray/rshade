module RShade
  class EventObserver
    attr_reader :event_store, :config

    def initialize(config)
      @event_store = EventStore.new
      @event_store = config
      @depth = 0
      @hook = Hash.new(0)
      @hook[:enter] = 1
      @hook[:leave] = -1
    end

    # @param [:enter, :leave, :other] type
    # @param [RShade::Event] event
    def call(event, type)
      @depth += @hook[type]
      return unless pass?(event)

      enter(event) if type == :enter
      leave(event) if type == :leave
      other(event) if type == :other
    end

    private

    def enter(event)
      event_store.<<(event, @depth)
    end

    def leave(event)
      event_store.<<(event, @depth)
    end

    def other(event)

    end

    def pass?(event)
      grouped_filters = config.filters.group_by { |filter| filter.name }
      return true if grouped_filters[::RShade::AbstractFilter::VariableFilter::NAME]&.any? { |filter| filter.call(event) }
      return true if grouped_filters[::RShade::AbstractFilter::IncludePathFilter::NAME]&.any? { |filter| filter.call(event) }
      return false if grouped_filters[::RShade::AbstractFilter::ExcludePathFilter::NAME]&.any? { |filter| filter.call(event) }

      true
    end
  end
end