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
        if arg1.is_a?(Array)
          arg1 = traverse(arg1)
        else
          arg1 = RShade::Filter::FilterComposition.new(arg1)
        end

        if arg2.is_a?(Array)
          arg2 = traverse(arg2)
        else
          arg2 = RShade::Filter::FilterComposition.new(arg2)
        end

        RShade::Filter::FilterComposition.new(op, arg1, arg2)
      end
    end
  end
end