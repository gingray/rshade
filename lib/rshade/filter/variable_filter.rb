# frozen_string_literal: true

module RShade
  module Filter
    class VariableFilter < AbstractFilter
      attr_reader :matchers

      NAME = :variable_filter

      def initialize
        super
        @matchers = []
      end

      def name
        :variable_filter
      end

      def priority
        2
      end

      def call(event)
        matchers.each do |match|
          event.vars.each do |name, value|
            return true if match.call(name, value)
          end
        end
        false
      end

      def config_call(&block)
        matchers << block
      end
    end
  end
end
