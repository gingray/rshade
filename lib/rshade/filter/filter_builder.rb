# frozen_string_literal: true

module RShade
  module Filter
    class FilterBuilder
      def self.build(arr)
        new.traverse(arr)
      end

      def map
        {
          or: [RShade::Filter::FilterComposition::OR_OP, 2],
          and: [RShade::Filter::FilterComposition::AND_OP, 2],
          unary: [RShade::Filter::FilterComposition::UNARY_OP, 1]
        }
      end

      def traverse(arr)
        op, arity = map[arr[0]]
        arg1 = arr[1]
        arg2 = nil
        arg2 = arr[2] if arity == 2
        arg1 = if arg1.is_a?(Array)
                 traverse(arg1)
               else
                 RShade::Filter::FilterComposition.new(arg1)
               end

        arg2 = if arg2.is_a?(Array)
                 traverse(arg2)
               else
                 RShade::Filter::FilterComposition.new(arg2)
               end

        RShade::Filter::FilterComposition.new(op, arg1, arg2)
      end
    end
  end
end
