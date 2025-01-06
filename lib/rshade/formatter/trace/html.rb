# frozen_string_literal: true

require 'json'

module RShade
  module Formatter
    module Trace
      class Html
        attr_reader :formatter

        FILE_NAME = 'stacktrace.html'
        TEMPLATE = 'html/template.html.erb'

        def initialize(args = {})
          @formatter = args.fetch(:formatter, Json)
        end

        # @param [RShade::EventProcessor] event_store
        def call(event_store)
          data = formatter.call(event_store)
          erb_template = ERB.new(template)
          content = erb_template.result_with_hash({ json: data.to_json })
          write_to_file(content)
        end

        def write_to_file(data)
          ::File.open(::File.join(RShade::Config.store_dir, FILE_NAME), 'w+') do |f|
            f.write data
          end
        end

        def template
          @template ||= ::File.read(::File.join(::RShade::Config.root_dir, TEMPLATE))
        end
      end
    end
  end
end
