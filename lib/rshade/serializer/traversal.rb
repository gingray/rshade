# frozen_string_literal: true

module RShade
  module Serializer
    class Traversal
      attr_reader :types

      def initialize(custom_types = {})
        @types = default_types.merge(custom_types)
      end

      def call(hash)
        new_val = {}
        hash.each do |name, value|
          new_val[name] = traverse(value)
        end
        new_val
      end

      def default_types
        {
          default: lambda(&:to_s),
          Integer => ->(value) { value },
          Float => ->(value) { value },
          Numeric => ->(value) { value },
          String => ->(value) { value },
          Hash => lambda do |value|
            hash = {}
            value.each do |k, v|
              hash[k] = traverse(v)
            end
            hash
          end,
          Array => lambda do |value|
            value.map { |item| traverse(item) }
          end
        }
      end

      def traverse(value)
        klass = value
        klass = value.class unless value.is_a?(Class)
        serializer = types[klass]
        serializer ||= types[:default]
        serializer.call(value)
      end
    end
  end
end
