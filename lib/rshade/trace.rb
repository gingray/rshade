# frozen_string_literal: true

module RShade
  class Trace
    attr_reader :config, :event_store

    # @param [RShade::Config,RShade::Config::EventStore] config
    def initialize(config: ::RShade::Config::Registry.instance.default_trace_config)
      @config = config
      @event_store = EventTree.new
    end

    def self.reveal(config: ::RShade::Config::Registry.instance.default_trace_config, &block)
      new(config: config).reveal(&block)
    end

    def reveal(&block)
      processor = EventProcessor.new(event_store, config)
      observer = EventObserver.new(config, processor)
      observable = RShade::TraceObservable.new([observer], config)
      observable.reveal(&block)
      self
    end

    def show
      config.formatter.call(event_store)
    end
  end
end
