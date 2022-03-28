module RShade
  module Serializer
    class Traversal
      attr_reader :types
      def initialize(custom_types)
        @types = default_types.merge(custom_types)
      end

      def call(hash)
        serialized_val = {}
        hash.each do |name, value|
          serialized_val[name] = traverse(value)
        end
      end

      def default_types
        {
          default: ->(value) { value.inspect },
          Hash => ->(value) do
            temp = {}
            value.each do |k,v|
              temp[k] = traverse(v)
            end
            temp
          end,
          Array => ->(value) do
            value.map { |item| traverse(item) }
          end
        }
      end

      def traverse(value)
        klass = value
        klass = value.class unless value.is_a?(Class)
        serializer = types[klass]
        serializer = types[:default] unless serializer
        serializer.call(value)
      end
    end
  end
end