module RShade
  module Formatter
    class Stdout < String
      def call
        buffer = super
        puts buffer
      end
    end
  end
end