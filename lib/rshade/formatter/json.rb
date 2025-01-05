# frozen_string_literal: true

module RShade
  module Formatter
    class Json
      attr_reader :event_processor

      # @param [RShade::EventProcessor] event_store
      def call(event_store)
        @event_store = event_store
        flat
      end

      def flat
        arr = []
        event_store.each do |node|
          arr << item(node.event)
        end
        arr.sort_by { |item| item[:level] }
      end

      def hierarchical
        hash = {}
        event_store.each do |node|
          depth = node.level
          ref = hash_iterate(hash, depth)
          ref[:data] = item(node)
        end
        sort_hash(hash)
      end

      def sort_hash(h)
        {}.tap do |h2|
          h.sort.each do |k, v|
            h2[k] = v.is_a?(Hash) ? sort_hash(v) : v
          end
        end
      end

      def hash_iterate(hash, depth)
        (0..depth).each do |_lvl|
          hash[:inner] = {} unless hash[:inner]
          hash = hash[:inner]
        end
        hash
      end

      def item(value)
        {
          class: value.klass.to_s,
          method_name: value.method_name,
          full_path: "#{value.path}:#{value.lineno}",
          level: value.depth,
          vars: value.vars
        }
      end
    end
  end
end
