# frozen_string_literal: true

module RShade
  class TraceObservable
    include Observable
    attr_reader :trace_p

    CALL_EVENTS = Set[:call, :c_call, :b_call]
    RETURN_EVENTS = Set[:return, :c_return, :b_return]

    # @param [Enumerable<#call>, #call] observers
    # @param [::RShade::Config::EventStore] config
    def initialize(observers, config)
      @trace_p = TracePoint.new(*config.tp_events, &method(:process))
      observers = [observers] unless observers.is_a?(Enumerable)

      observers.each do |observer|
        add_observer(observer, :call)
      end
    end

    def reveal
      return unless block_given?

      trace_p.enable
      yield
      self
    ensure
      trace_p.disable
    end

    private

    # more info https://rubyapi.org/3.1/o/tracepoint
    # @param [TracePoint] trace_point
    def process(trace_point)
      changed
      event = Event.from_trace_point(trace_point)
      return notify_observers(event, :enter) if CALL_EVENTS.include?(trace_point.event)
      return notify_observers(event, :leave) if RETURN_EVENTS.include?(trace_point.event)

      notify_observers(event, :other)
    end
  end
end
