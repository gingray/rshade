module RShade
  class Trace
    attr_accessor :source_tree, :options
    EVENTS = %i[call return].freeze

    def initialize
      @source_tree = Event.new(nil)
      @tp = TracePoint.new(*EVENTS, &method(:process_trace))
      @stack = [@source_tree]
    end

    def reveal(options = {})
      return unless block_given?

      @tp.enable
      yield
    ensure
      @tp.disable
    end

    def show
      filter = RShade.configuration.filter
      formatter = RShade.configuration.formatter
      formatter.call(filter.call(source_tree))
    end

    def process_trace(tp)
      if tp.event == :call
        parent = @stack.last
        vars = {}
        tp.binding.local_variables.each do |var|
          vars[var] = tp.binding.local_variable_get var
        end
        hash = { level: @stack.size, path: tp.path, lineno: tp.lineno, klass: tp.defined_class, method_name: tp.method_id, vars: vars }
        node = Event.new(Code.new(hash))
        node.parent = parent
        parent << node
        @stack.push node
      end

      if tp.event == :return && @stack.size > 1
        @stack.pop
      end
    end
  end
end
