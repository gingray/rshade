# frozen_string_literal: true

module RShade
  class Config
    class StackStore
      attr_reader :filter, :formatter, :variable_serializer

      DEFAULT_FORMATTER = {
        json: ::RShade::Formatter::Stack::Json,
        stdout: ::RShade::Formatter::Stack::Stdout
      }.freeze

      # @param [RShade::Formatter::Stack::Stdout] formatter
      # @param [RShade::Filter::FilterComposition] filter
      # @param [Hash] serializers
      def initialize(formatter: RShade::Formatter::Stack::Stdout.new, filter: default_filter_composition,
                     serializers: {})
        @filter = filter
        @formatter = formatter
        @variable_serializer = ::RShade::Serializer::Traversal.new(serializers)
      end

      def serializer!(hash)
        variable_serializer.merge!(hash)
        self
      end

      def filter!(filter_type, &block)
        filter.filter(filter_type, &block)
        self
      end

      def formatter!(formatter, opts = {})
        @formatter = formatter.is_a?(Symbol) ? set_symbol_formatter(formatter, opts) : formatter
        self
      end

      def exclude_gems!
        filter!(::RShade::Filter::ExcludePathFilter) do |paths|
          paths.concat(RShade::Utils.default_excluded_path)
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
        variable_filter = RShade::Filter::VariableFilter.new
        include_filter = RShade::Filter::IncludePathFilter.new
        exclude_filter = RShade::Filter::ExcludePathFilter.new

        RShade::Filter::FilterBuilder.build([:or,
                                             [:or, variable_filter, include_filter], exclude_filter])
      end
    end
  end
end
