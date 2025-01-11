# frozen_string_literal: true

module RShade
  module Formatter
    module Trace
      class Json
        attr_reader :filepath, :pretty

        def initialize(filepath:, pretty: false)
          @filepath = filepath
          @pretty = pretty
        end

        # @param [RShade::EventProcessor] event_store
        def call(event_store)
          ::File.open(filepath, 'a+') do |file|
            file.puts(convert_to_json(flat(event_store), pretty))
          end
        end

        private

        def convert_to_json(object, pretty)
          return JSON.pretty_generate(object) if pretty

          JSON.generate(object)
        end

        def flat(event_store)
          arr = event_store.filter_map do |node|
            next unless node.value

            serialize(node.value)
          end
          arr.sort_by { |item| item[:level] }
        end

        def serialize(value)
          {
            class: value.klass.to_s,
            method_name: value.method_name,
            full_path: "#{value.path}:#{value.lineno}",
            level: value.level,
            vars: value.vars
          }
        end
      end
    end
  end
end
