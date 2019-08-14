module RShade
  class Trace
    attr_accessor :source_tree, :open, :close, :set
    EVENTS = %i[call return].freeze

    def initialize
      @source_tree = SourceNode.new(nil)
      @tp = TracePoint.new(*EVENTS, &method(:process_trace))
      @stack = [@source_tree]
    end

    def reveal
      return unless block_given?

      @tp.enable
      yield
    ensure
      @tp.disable
    end

    def show(type = ::RShade::APP_TRACE)
      return show_app_trace if type == ::RShade::APP_TRACE

      show_full_trace
    end

    def show_full_trace(tree = nil)
      buffer = StringIO.new
      tree ||= source_tree
      tree.pre_order_traverse do |node, depth|
        if node.root?
          buffer << "---\n"
          next
        end

        buffer << "#{'  ' * depth} #{node.value.pretty}\n" if node.value
      end
      puts buffer.string
    end

    def show_app_trace
      clone = source_tree.clone_by do |node|
        next true if node.root?

        node.value.app_code?
      end
      show_full_trace(clone)
    end

    def process_trace(tp)
      if tp.event == :call
        parent = @stack.last
        vars = {}
        tp.binding.local_variables.each do |var|
          vars[var] = tp.binding.local_variable_get var
        end
        hash = { level: @stack.size, path: tp.path, lineno: tp.lineno, klass: tp.defined_class, method_name: tp.method_id, vars: vars }
        node = SourceNode.new(Source.new(hash))
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
