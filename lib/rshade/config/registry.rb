# frozen_string_literal: true

module RShade
  class Config
    class Registry
      include Singleton
      attr_reader :map, :mutex

      def initialize
        @map = {}
        @mutex = Mutex.new
        defaults
      end

      def default_stack_config
        val = nil
        mutex.synchronize do
          val = map[:store_default]
        end
        val
      end

      def stack_config(&block)
        val = nil
        mutex.synchronize do
          val = ::RShade::Config::StackStore.new
          block.call(val)
          map[:store_default] = val
        end
        val
      end

      def defaults
        mutex.synchronize do
          map[:store_default] = ::RShade::Config::StackStore.new
        end
      end
    end
  end
end
