module RShade
  module Filter
    class FilterComposition
      include Enumerable
      AND_OP = :and
      OR_OP = :or
      UNARY_OP = :unary
      OPS = [AND_OP, OR_OP, UNARY_OP]
      attr_reader :value, :left, :right, :parent
      attr_accessor :parent

      # @param [#call, Enumerable] left
      # @param [#call, Enumerable] right
      def initialize(value, left=nil, right=nil)
        @value = value
        @left = left
        @right = right
      end

      def call(event)
        case value
        when UNARY_OP
          return left&.call(event)
        when AND_OP
          return left&.call(event) && right&.call(event)
        when OR_OP
          l = left&.call(event)
          r = right&.call(event)
          # puts "#{left} => #{l} OR #{right} => #{r}"
          return l || r
        else
          value.call(event)
        end
      end

      def each(&block)
        yield value unless OPS.include?(value)
        left&.each(&block)
        right&.each(&block)
      end

      def config_filter(type, &block)
        filter = find do |filter|
          filter.is_a? type
        end
        filter.config(&block) if filter
      end

      def self.build(arr)
        ::RShade::Filter::FilterBuilder.build(arr)
      end
    end
  end
end