module RShade
  module Formatter
    class Stdout < String
      def call(event_store)
        puts super(event_store)
      end
    end
  end
end