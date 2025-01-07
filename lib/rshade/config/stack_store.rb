# frozen_string_literal: true

module RShade
  class Config
    class StackStore
      attr_reader :filter, :formatter, :custom_serializers

      DEFAULT_FORMATTER = {
        json: ::RShade::Formatter::Stack::Json
      }.freeze

      # @param [Hash] options
      # @option options [::RShade::Filter::FilterComposition] :filter_composition
      # @option options [#call(event_store)] :formatter
      def initialize(options = {})
        @filter = options.fetch(:filter, default_filter_composition)
        @formatter = options.fetch(:formatter, ::RShade::Formatter::Stack::Stdout.new)
        @custom_serializers = options.fetch(:custom_serializers, {})
      end

      def add_custom_serializers(hash)
        custom_serializers.merge!(hash)
        self
      end

      def config_filter(filter_type, &block)
        filter.config_filter(filter_type, &block)
        self
      end

      def set_formatter(formatter, opts = {})
        @formatter = formatter.is_a?(Symbol) ? set_symbol_formatter(formatter, opts) : formatter
        self
      end

      def exclude_gems!
        config_filter(::RShade::Filter::ExcludePathFilter) do |paths|
          paths.concat(RShade::Config.default_excluded_path)
        end
        self
      end

      private

      def set_symbol_formatter(type, opts)
        formatter_class = DEFAULT_FORMATTER[type]
        return formatter_class unless formatter_class

        @formatter = formatter_class.new(**opts)
      end

      def default_filter_composition
        RShade::Filter::FilterBuilder.build([:or,
                                             [:or, RShade::Filter::VariableFilter.new, RShade::Filter::IncludePathFilter.new], RShade::Filter::ExcludePathFilter.new])
      end
    end
  end
end
