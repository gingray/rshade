module RShade
  class Trace
    attr_accessor :source_tree, :open, :close, :set
    EVENTS = %i[call return].freeze
    MAX = 20

    def initialize
      @source_tree = SourceNode.new(nil, RShade::SourceValue.new(level:0))
      @tp = TracePoint.new(*EVENTS, &method(:process_trace))
      @filter = RShade::Filter.new
      @stack = [@source_tree]
      @find_user_code = false
      @set = Set.new
    end

    def reveal
      return unless block_given?
      @tp.enable
      yield
    ensure
      @tp.disable
    end

    def show(&block)
      return @source_tree.duplicate(&block).print_tree if block_given?

      @source_tree.print_tree
    end

    def process_trace(tp)
      if tp.event == :call
        return unless @filter.call(tp.path)

        parent = @stack.last
        return unless parent && @stack.size < MAX

        hash = { level: @stack.size, path: tp.path, lineno: tp.lineno, klass: tp.defined_class, method: tp.method_id }
        value = SourceValue.new(hash)
        node = SourceNode.new(parent, value)
        parent.add node
        @stack.push node
      end

      if tp.event == :return
        return unless @filter.call(tp.path)

        @stack.pop if @stack.size > 1
      end
    end
  end
end
