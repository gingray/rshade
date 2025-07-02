# frozen_string_literal: true

module RShade
  # nodoc
  class EventProcessor
    attr_reader :event_tree, :serializer

    # @param [RShade::EventTree] event_tree
    def initialize(event_tree, config)
      @event_tree = event_tree
      custom_serializers = config.variable_serializer
      @serializer = ::RShade::Serializer::Traversal.new(custom_serializers)
    end

    # @param [RShade::Event] event
    # @param [Integer] level
    def enter(event, level)
      event.with_serialized_vars!(serializer).with_level!(level)
      event_tree.add(event, level)
    end

    # @param [RShade::Event] event
    # @param [Integer] level
    def leave(event, _level)
      event_tree.current! do |node|
        node.value.return_value!(event.return_value)
            .with_serialized_return!(serializer)
      end
    rescue StandardError
      # this rescue here due this issue which reproduce in ruby-2.6.6 at least
      # https://bugs.ruby-lang.org/issues/18060
    end

    # @param [RShade::Event] event
    # @param [Integer] level
    def other(event, level); end
  end
end
