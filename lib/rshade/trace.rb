module RShade
  class Trace
    attr_accessor :source_tree, :formatter, :filter
    EVENTS = %i[call return].freeze

    def initialize(options={})
      @source_tree = Event.new(nil)
      @formatter = options.fetch(:formatter, RShade.config.formatter)
      @filter = options.fetch(:filter, RShade.config.filter)
      @tp = TracePoint.new(*EVENTS, &method(:process_trace))
      @stack = [@source_tree]
      @stat = {}
      @calls = 0
      @returns = 0
    end

    def self.reveal(options={}, &block)
      new(options).reveal(&block)
    end

    def reveal
      return unless block_given?

      @tp.enable
      yield
      self
    ensure
      @tp.disable
    end

    def show
      puts "STATS: #{stat}"
      formatter.call(source_tree)
    end

    def stat
      { calls: @calls, returns: @returns }
    end

    def process_trace(tp)
      if tp.event == :call
        parent = @stack.last
        vars = {}
        tp.binding.local_variables.each do |var|
          vars[var] = tp.binding.local_variable_get var
          vars[var] = vars[var].encode('UTF-8', invalid: :replace, undef: :replace, replace: '?') if vars[var].is_a?(String)
        end
        hash = { level: @stack.size, path: tp.path, lineno: tp.lineno, klass: tp.defined_class, method_name: tp.method_id, vars: vars }
        return unless filter.call(hash)
        @calls += 1
        node = Event.new(Code.new(hash))
        node.parent = parent
        parent << node
        @stack.push node
      end

      if tp.event == :return && @stack.size > 1
        @returns += 1
        @stack.pop
      end
    end
  end
end
