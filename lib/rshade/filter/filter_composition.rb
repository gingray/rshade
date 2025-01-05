# frozen_string_literal: true

module RShade
  module Filter
    class FilterComposition
      include Enumerable
      AND_OP = :and
      OR_OP = :or
      UNARY_OP = :unary
      attr_reader :value, :left, :right, :parent
      attr_accessor :parent

      # @param [#call, Enumerable] left
      # @param [#call, Enumerable] right
      def initialize(value, left = nil, right = nil)
        @value = value
        @left = left
        @right = right
      end

      def call(event)
        case value
        when UNARY_OP
          left&.call(event)
        when AND_OP
          left&.call(event) && right&.call(event)
        when OR_OP
          left&.call(event) || right&.call(event)
        else
          value.call(event)
        end
      end

      def each(&block)
        yield value unless left && right
        left&.each(&block)
        right&.each(&block)
      end

      def config_filter(type, &block)
        filter = find do |filter|
          filter.is_a? type
        end
        filter&.config(&block)
      end

      # for debug purposes, show each filter and result of evaluation
      def filter_results(event)
        each_with_object([]) do |filter, arr|
          arr << [filter, filter.call(event)]
        end
      end

      def self.build(arr)
        ::RShade::Filter::FilterBuilder.build(arr)
      end
    end
  end
end
