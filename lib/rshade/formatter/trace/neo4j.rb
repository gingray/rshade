# frozen_string_literal: true

require 'digest'

module RShade
  module Formatter
    module Trace
      class Neo4j
        attr_reader :filepath, :class_hash

        def initialize(filepath:)
          @filepath = filepath
          @class_hash = {}
        end

        # @param [RShade::EventProcessor] event_store
        def call(event_store)
          ::File.open(filepath, 'a+') do |file|
            file.puts(flat(event_store))
          end
        end

        private

        def flat(event_store)
          # use previous value no create graph of calls
          arr = event_store.filter_map do |node|
            next unless node.value

            serialize(node.value)
          end
          arr.sort_by { |item| item[:level] }
        end

        def serialize(value)
          key = generate_key(value)
          get_uniq_key(class_hash, key)
          {
            class: value.klass.to_s,
            method_name: value.method_name,
            full_path: "#{value.path}:#{value.lineno}",
            level: value.level,
            vars: value.vars
          }
        end

        def generate_key(value)
          "#{value[:class]}:#{value[:method_name]}"
        end

        def get_uniq_key(class_hash, key)
          hashed_key = Digest::MD5.hexdigest(key)
          return class_hash[key] if class_hash[key]

          class_hash[key] = hashed_key
          hashed_key
        end
      end
    end
  end
end
