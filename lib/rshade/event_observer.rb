module RShade
  class EventObserver
    attr_reader :event_processor, :config

    # @param [RShade::Config::Store] config
    # @param [RShade::EventProcessor] event_store
    def initialize(config, event_processor)
      @event_processor = event_processor
      @config = config
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

      enter(event) if type == :enter
      leave(event) if type == :leave
      other(event) if type == :other
    end

    private

    def enter(event)
      event_processor.enter event, @level
    end

    def leave(event)
      event_processor.leave event, @level
    end

    def other(event)
      event_processor.other event, @level
    end

    def pass?(event)
      grouped_filters = config.filters.group_by { |filter| filter.name }
      return true if grouped_filters[::RShade::Filter::VariableFilter::NAME]&.any? { |filter| filter.call(event) }
      return true if grouped_filters[::RShade::Filter::IncludePathFilter::NAME]&.any? { |filter| filter.call(event) }
      return false if grouped_filters[::RShade::Filter::ExcludePathFilter::NAME]&.any? { |filter| filter.call(event) }

      true
    end
  end
end