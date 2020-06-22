module RShade
  module Formatter
    class Stdout < String
      def call
        buffer = super
        puts buffer.string
      end
    end
  end
end