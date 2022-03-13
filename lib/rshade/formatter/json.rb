module RShade
  module Formatter
    class Json < ::RShade::Base
      attr_reader :event_store

      def initialize(event_store)
        @event_store = event_store
      end

      def call
        flat
      end

      def flat
        arr = []
        event_store.each do |node|
          arr << item(node.event)
        end
        arr.sort_by { |item| item[:depth]}
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
          h.sort.each do |k,v|
            h2[k] = v.is_a?(Hash) ? sort_hash(v) : v
          end
        end
      end

      def hash_iterate(hash, depth)
        (0..depth).each do |lvl|
          unless hash[:inner]
            hash[:inner] = {}
          end
          hash = hash[:inner]
        end
        hash
      end

      def item(value)
        vars = value.vars.map { |key, val| [k, val[:copy]]}.to_h

        {
            class: value.klass.to_s,
            method_name: value.method_name,
            full_path: "#{value.path}:#{value.lineno}",
            depth: value.depth,
            vars: vars
        }
      end
    end
  end
end