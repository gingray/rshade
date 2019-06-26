module RShade
  class Trace
    attr_accessor :source_tree
    EVENTS = %i[call return].freeze

    def initialize
      @source_tree = SourceNode.new(nil, RShade::SourceValue.new)
      @current_node = nil
      @tp = TracePoint.new(*EVENTS, &method(:process_trace))
      @level = 0
      @filter = RShade::Filter.new
    end

    def reveal
      return unless block_given?

      @tp.enable
      yield
      @tp.disable
    end

    def show(&block)
      return @source_tree.duplicate(&block).print_tree if block_given?

      @source_tree.print_tree
    end

    def process_trace(tp)
      @current_node ||= @source_tree
      if tp.event == :call
        return unless @filter.call(tp.path)

        hash = { level: @level + 1, path: tp.path, lineno: tp.lineno, klass: tp.defined_class, method: tp.method_id }
        value = SourceValue.new(hash)
        node = SourceNode.new(@current_node, value)
        @current_node.nodes << node
        @current_node = node
      end

       if tp.event == :return
         return unless @filter.call(tp.path)
         @level -= 1
         @current_node = @current_node.parent
       end
    end
  end
end
