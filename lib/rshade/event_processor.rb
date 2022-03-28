module RShade
  # nodoc
  class EventProcessor
    attr_reader :store

    def initialize(store)
      @store = store
      @var_serializer = ::RShade::Serializer::Traversal.new
    end

    # @param [RShade::Event] event
    # @param [Integer] level
    def enter(event, level)
      event.with_serialized_vars!(@var_serializer).with_level!(level)
      store.add(event, level)
    end

    # @param [RShade::Event] event
    # @param [Integer] level
    def leave(event, level)
      store.current! do |node|
          node.value.set_return_value!(event.return_value)
              .with_serialized_return!(->(value) { value.inspect })
      end
    rescue => e
      # this rescue here due this issue which reproduce in ruby-2.6.6 at least
      # https://bugs.ruby-lang.org/issues/18060
    end
    # @param [RShade::Event] event
    # @param [Integer] level
    def other(event, level)

    end
  end
end