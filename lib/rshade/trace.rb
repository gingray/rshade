module RShade
  class Trace
    include RShade::Helper
    attr_accessor :source_tree, :open, :close, :set
    EVENTS = %i[call return].freeze

    def initialize
      @source_tree = SourceNode.new(nil)
      @tp = TracePoint.new(*EVENTS, &method(:process_trace))
      @filter = RShade::Filter.new
      @stack = [@source_tree]
    end

    def reveal
      return unless block_given?

      @tp.enable
      yield
    ensure
      @tp.disable
    end

    def show
      @source_tree.filter do |node|
        next true unless node.parent

        @filter.call(node.path)
      end
      pretty_print @source_tree
    end

    def process_trace(tp)
      if tp.event == :call
        parent = @stack.last
        hash = { level: @stack.size, path: tp.path, lineno: tp.lineno, klass: tp.defined_class, method_name: tp.method_id }
        node = SourceNode.new(parent, hash)
        parent.add node
        @stack.push node
      end

      @stack.pop if tp.event == :return && @stack.size > 1
    end
  end
end
