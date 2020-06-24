module RShade
  module Formatter
    class Json < ::RShade::Base
      attr_reader :event_store
      FILE_NAME = 'stacktrace.json'.freeze

      def initialize(event_store)
        @event_store = event_store
      end

      def call
        hash = {}
        event_store.iterate do |node, depth|
          ref = hash_iterate(hash, depth)
          ref[:data] = item(node)
        end
        hash = sort_hash(hash)
        write_to_file(JSON.pretty_generate(hash))
        hash
      end

      def write_to_file(data)
        File.open(File.join(RShade.config.store_dir, FILE_NAME), "w+") do |f|
          f.write data
        end
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
        {
            class: value.klass.to_s,
            method_name: value.method_name,
            full_path: "#{value.path}:#{value.lineno}",
            vars: {}
        }
      end
    end
  end
end