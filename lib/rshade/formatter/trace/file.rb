# frozen_string_literal: true

module RShade
  module Formatter
    module Trace
      class File
        attr_reader :formatter

        FILE_NAME = 'stacktrace.json'

        def initialize(args = {})
          @formatter = args.fetch(:format, Json)
        end

        # @param [RShade::EventProcessor] event_store
        def call(event_store)
          data = formatter.call(event_store)
          if formatter == Json
            write_to_file(JSON.pretty_generate(data))
          else
            write_to_file(data.to_s)
          end
        end

        def write_to_file(data)
          ::File.open(::File.join(RShade::Config.store_dir, FILE_NAME), 'w+') do |f|
            f.write data
          end
        end
      end
    end
  end
end
