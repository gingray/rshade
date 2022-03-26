
module RShade
  class Config
    class Store
      attr_reader :filter_composition, :formatter, :tp_events

      def initialize(options={})
        @filter_composition = options.fetch(:filter_composition, default_filter_composition)
        @formatter = ::RShade::Formatter::Stdout
        @tp_events = [:call, :return]
      end

      def set_tp_events(tp_events)
        @tp_events = tp_events
      end

      def config_filter(filter_type, &block)
        filter_composition.config_filter(filter_type, &block)
        self
      end

      def set_formatter(formatter)
        @formatter = formatter
        self
      end

      private

      def default_filter_composition
        RShade::Filter::FilterBuilder.build([:or,[:or, RShade::Filter::VariableFilter.new, RShade::Filter::IncludePathFilter.new] , RShade::Filter::ExcludePathFilter.new])
      end
    end
  end
end
