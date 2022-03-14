module RShade
  module Formatter
    class Stdout < String
      # @param [RShade::EventStore] event_store
      def call(event_store)
        puts super(event_store)
      end
    end
  end
end