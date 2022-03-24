module RShade
  module Filter
    class FilterBuilder
      def build
        # {or: [f1, {and: [f2, {or: [f3, f4]}]}]}
        # [[:or, f1, [:and, f2, f3]]]
        # [:unary, f1]
      end
    end
  end
end