
module RShade
  class Config
    class Store
      attr_reader :filters, :formatter, :tp_events

      def initialize
        @filters = []
        @formatter = ::RShade::Formatter::Stdout
        @tp_events = [:call, :return]
      end

      def self.create(filters, formatter)
        new.add_filter(filters).set_formatter(formatter)
      end

      def set_tp_events(tp_events)
        @tp_events = tp_events
      end

      def add_filter(filters)
        @filters.append(filters)
        @filters = @filters.flatten.sort_by { |filter| filter.priority }.reverse
        self
      end

      def set_formatter(formatter)
        @formatter = formatter
        self
      end
    end
  end
end
