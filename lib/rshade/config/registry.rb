# frozen_string_literal: true

module RShade
  class Config
    class Registry
      include Singleton
      attr_reader :map, :mutex

      DEFAULT_EVENT_STORE = :event_store_default
      DEFAULT_STACK_STORE = :stack_store_default

      def initialize
        @map = {}
        @mutex = Mutex.new
        defaults
      end

      def default_stack_config
        val = nil
        mutex.synchronize do
          val = map[DEFAULT_STACK_STORE]
        end
        val
      end

      def stack_config(&block)
        val = nil
        mutex.synchronize do
          val = ::RShade::Config::StackStore.new
          block.call(val)
          map[DEFAULT_STACK_STORE] = val
        end
        val
      end

      def default_trace_config
        val = nil
        mutex.synchronize do
          val = map[DEFAULT_EVENT_STORE]
        end
        val
      end

      def trace_config(&block)
        val = nil
        mutex.synchronize do
          val = ::RShade::Config::EventStore.new
          block.call(val)
          map[DEFAULT_EVENT_STORE] = val
        end
        val
      end

      def defaults
        mutex.synchronize do
          stack_store = ::RShade::Config::StackStore.new
          stack_store.exclude_gems!
          map[DEFAULT_STACK_STORE] = stack_store

          event_store = ::RShade::Config::EventStore.new
          event_store.exclude_gems!
          map[DEFAULT_EVENT_STORE] = event_store
        end
      end
    end
  end
end
