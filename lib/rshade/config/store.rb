
module RShade
  class Config
    class Store
      attr_reader :filters, :formatter

      def initialize(filters, formatter)
        @filters = filters.sort_by { |filter| filter.priority }
        @formatter = formatter
      end

      def self.create(filters, formatter)
        new(filters, formatter)
      end

      def apply_filters(event)
        filters.any? { |filter| filter.call(event) }
      end
    end
  end
end
