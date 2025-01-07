# frozen_string_literal: true

module RShade
  module Formatter
    module Trace
      class Stdout < String
        # @param [RShade::EventProcessor] event_store
        def call(event_store)
          puts super
        end
      end
    end
  end
end
