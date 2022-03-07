require 'json'

module RShade
  module Formatter
    class Html < ::RShade::Base
      attr_reader :formatter, :event_store
      FILE_NAME = 'stacktrace.html'.freeze
      TEMPLATE = 'html/template.html.erb'

      def initialize(event_store, args={})
        @event_store = event_store
        @formatter = args.fetch(:formatter, Json)
      end

      def call
        data = formatter.call(event_store)
        erb_template = ERB.new(template)
        content = erb_template.result_with_hash({json: data.to_json})
        write_to_file(content)
      end

      def write_to_file(data)
        ::File.open(::File.join(RShade::Config.store_dir, FILE_NAME), "w+") do |f|
          f.write data
        end
      end

      def template
        @template ||=::File.read(::File.join(::RShade::Config.root_dir, TEMPLATE))
      end
    end
  end
end