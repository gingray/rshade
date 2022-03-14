module RShade
  class Trace2
    include Observable
    attr_reader :trace_p
    CALL_EVENTS = Set[:call, :c_call, :b_call]
    RETURN_EVENTS = Set[:return, :c_return, :b_return]
    OTHER_EVENTS = Set[:line, :raise]


    # @param [Enumerable<#call>, #call] observers
    def initialize(observers)
      events = (CALL_EVENTS | RETURN_EVENTS | OTHER_EVENTS).to_a
      @trace_p = TracePoint.new(*events, &method(:process))
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
    # @param [TracePoint] tp
    def process(tp)
      changed
      event = Event.from_trace_point(tp)
      notify_observers(event, :enter) if CALL_EVENTS.include?(tp.event)
      notify_observers(event, :leave) if RETURN_EVENTS.include?(tp.event)
      notify_observers(event, :other) if OTHER_EVENTS.include?(tp.event)
    end
  end
end
