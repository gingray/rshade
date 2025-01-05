# frozen_string_literal: true

module RShade
  module Filter
    class AbstractFilter
      def name
        raise NotImplementedError
      end

      def priority
        raise NotImplementedError
      end

      def call(event)
        raise NotImplementedError
      end

      def config_call
        raise NotImplementedError
      end

      def config(&block)
        config_call(&block)
        self
      end
    end
  end
end
