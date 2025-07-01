# frozen_string_literal: true

module RShade
  class Trace
    attr_reader :config, :event_tree

    # @param [RShade::Config,RShade::Config::EventStore] config
    def initialize(config: ::RShade::Config::Registry.instance.default_trace_config, event_tree: EventTree.new)
      @config = config
      @event_tree = event_tree
    end

    def self.reveal(config: ::RShade::Config::Registry.instance.default_trace_config, event_tree: EventTree.new, &block)
      new(config: config, event_tree: event_tree).reveal(&block)
    end

    def reveal(&block)
      processor = EventProcessor.new(event_tree, config)
      observer = EventObserver.new(event_processor: processor, filter: config.filter)
      observable = RShade::TraceObservable.new([observer], config)
      observable.reveal(&block)
      self
    end

    def show
      config.formatter.call(event_tree)
    end
  end
end
