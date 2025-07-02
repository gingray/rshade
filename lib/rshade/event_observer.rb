# frozen_string_literal: true

module RShade
  class EventObserver
    attr_reader :event_processor, :filter

    HOOK = {
      enter: 1,
      leave: -1
    }.freeze

    # @param [RShade::Filter::AbstractFilter] filter
    # @param [RShade::EventProcessor] event_processor
    def initialize(event_processor:, filter:)
      @event_processor = event_processor
      @filter = filter
      @level = 0
    end

    # @param [:enter, :leave, :other] type
    # @param [RShade::Event] event
    def call(event, type)
      @level += HOOK[type] || 0
      return unless filter.call(event)

      case type
      when :enter
        event_processor.enter(event, @level)
      when :leave
        event_processor.leave(event, @level)
      when :other
        event_processor.other(event, @level)
      end
    rescue StandardError => e
      puts e
    end
  end
end
