module RShade
  module Formatter
    class File < ::RShade::Base
      attr_reader :formatter, :event_store
      FILE_NAME = 'stacktrace.json'.freeze

      def initialize(event_store, args={})
        @event_store = event_store
        @formatter = args.fetch(:format, Json)
      end

      def call
        data = formatter.call(event_store)
        if formatter == Json
          write_to_file(JSON.pretty_generate(data))
        else
          write_to_file(data.to_s)
        end
      end

      def write_to_file(data)
        ::File.open(::File.join(RShade.config.store_dir, FILE_NAME), "w+") do |f|
          f.write data
        end
      end
    end
  end
end