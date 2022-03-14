module RShade
  class Trace
    attr_reader :config, :event_store
    def initialize(config)
      @config = fetch_config(config)
      @event_store = EventStore.new
    end

    def self.reveal(config=nil, &block)
      new(config).reveal(&block)
    end

    def reveal(&block)
      observer = EventObserver.new(config, event_store)
      observable = RShade::TraceObservable.new([observer])
      observable.reveal &block
      self
    end

    def show
      config.formatter.call(event_store)
    end

    private
    def fetch_config(config)
      config = config || ::RShade::Config.default
      config = config.value if config.is_a?(::RShade::Config)
      config
    end
  end
end
