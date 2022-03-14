module RShade
  class Trace
    attr_reader :config
    def initialize(config)
      @config = config
    end

    def self.reveal(config=nil, &block)
      new(config).reveal(&block)
    end

    def reveal(&block)
      observer = EventObserver.new(config)
      observable = RShade::TraceObservable.new([observer])
      observable.reveal &block
      observer
    end
  end
end
