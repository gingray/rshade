module RShade
  # nodoc
  class EventProcessor
    attr_reader :store

    def initialize(store)
      @store = store
      @var_serializer = BindingSerializer.new
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
        # add return params to node
      end
    end
    # @param [RShade::Event] event
    # @param [Integer] level
    def other(event, level)

    end
  end
end