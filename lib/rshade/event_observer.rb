# frozen_string_literal: true

module RShade
  class EventObserver
    attr_reader :event_tree, :filter, :serializer

    HOOK = {
      enter: 1,
      leave: -1
    }.freeze

    # @param [RShade::Filter::AbstractFilter] filter
    # @param [RShade::EventProcessor] event_processor
    def initialize(event_tree:, filter:, serializer:)
      @event_tree = event_tree
      @filter = filter
      @serializer = serializer
      @level = 0
    end

    # @param [:enter, :leave, :other] type
    # @param [RShade::Event] event
    def call(event, type)
      @level += HOOK[type] || 0
      return unless filter.call(event)

      case type
      when :enter
        enter(event_tree, event, @level)
      when :leave
        leave(event_tree, event)
      when :other
      end
    rescue StandardError => e
      puts e
    end

    def enter(event_tree, event, level)
      event.with_serialized_vars!(serializer).with_level!(level)
      event_tree.add(event, level)
    end

    def leave(event_tree, event)
      event_tree.current! do |node|
        node.value.return_value!(event.return_value)
            .with_serialized_return!(serializer)
      end
    rescue StandardError
      # this rescue here due this issue which reproduce in ruby-2.6.6 at least
      # https://bugs.ruby-lang.org/issues/18060
    end
  end
end
