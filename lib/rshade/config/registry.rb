# frozen_string_literal: true

module RShade
  class Config
    class Registry
      attr_reader :map, :mutex

      include Singleton

      def initialize
        @map = {}
        @mutex = Mutex.new
        defaults
      end

      def set_default_stack(config)
        mutex.synchronize do
          map[:store_default] = config
        end
      end

      def default_stack_config
        val = nil
        mutex.synchronize do
          val = map[:store_default]
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
