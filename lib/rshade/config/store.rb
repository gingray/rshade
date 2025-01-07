# frozen_string_literal: true

module RShade
  class Config
    class Store
      attr_reader :filter_composition, :formatter, :tp_events, :custom_serializers

      # @param [Hash] options
      # @option options [RShade::Filter::FilterComposition] :filter_composition
      # @option options [#call(event_store)] :formatter
      # @option options [Array<Symbol>] :tp_events
      def initialize(options = {})
        @filter_composition = options.fetch(:filter_composition, default_filter_composition)
        @formatter = options.fetch(:formatter, ::RShade::Formatter::Trace::Stdout)
        @tp_events = options.fetch(:tp_events, %i[call return])
        @custom_serializers = options.fetch(:custom_serializers, {})
      end

      def set_tp_events(tp_events)
        @tp_events = tp_events
        self
      end

      def add_custom_serializers(hash)
        custom_serializers.merge!(hash)
        self
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
        RShade::Filter::FilterBuilder.build([:or,
                                             [:or, RShade::Filter::VariableFilter.new, RShade::Filter::IncludePathFilter.new], RShade::Filter::ExcludePathFilter.new])
      end
    end
  end
end
