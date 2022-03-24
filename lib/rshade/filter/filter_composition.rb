module RShade
  module Filter
    class FilterComposition
      include Enumerable
      AND_OP = :and
      OR_OP = :or
      UNARY_OP = :unary
      attr_reader :op, :left, :right

      # @param [#call, Enumerable] left
      # @param [#call, Enumerable] right
      def initialize(op=UNARY_OP, left=nil, right=nil)
        @op = op
        @left = left
        @right = right
      end

      def call(event)
        case op
        when UNARY_OP
          return left&.call(event)
        when AND_OP
          return left&.call(event) && right&.call(event)
        when OR_OP
          return left&.call(event) || right&.call(event)
        else
          raise 'undefined op'
        end
      end

      def each(&block)
        if left&.respond_to?(:each)
          left&.each(&block)
        else
          yield left
        end

        if right&.respond_to?(:each)
          right&.each(&block)
        else
          yield right
        end
      end

      def config_filter(type, &block)
        filter = find do |filter|
          filter.is_a? type
        end
        filter.config(&block) if filter
      end
    end
  end
end