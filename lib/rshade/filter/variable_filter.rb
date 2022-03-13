module RShade
  module Filter
    class VariableFilter < Base
      attr_reader :matchers
      def initialize
        @matchers = []
      end

      def name
        :variable_filter
      end

      def priority
        2
      end

      def call(event)
      end

      def config_call(&block)
        block.call(@matchers)
      end
    end
  end
end