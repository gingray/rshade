# frozen_string_literal: true

module RShade
  module Formatter
    class Stdout < String
      # @param [RShade::EventProcessor] event_store
      def call(event_store)
        puts super(event_store)
      end
    end
  end
end
