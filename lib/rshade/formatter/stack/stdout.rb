# frozen_string_literal: true

module RShade
  module Formatter
    module Stack
      class Stdout < String
        def call(stack)
          puts super
        end
      end
    end
  end
end
