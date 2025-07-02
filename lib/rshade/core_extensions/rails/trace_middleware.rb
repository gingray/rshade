# frozen_string_literal: true

module RShade
  module Rails
    class TraceMiddleware
      def initialize(app, options = {})
        @app = app
        @options = options
      end

      def call(env)
        traced_path = @options[:trace_regex]
        if traced_path&.match?(env['REQUEST_PATH'])
          puts "RShadeTrace #{traced_path} match #{env['REQUEST_PATH']} "
          trace = ::RShade::Trace.reveal do
            @app.call(env)
          end
          trace.show
        else
          @app.call(env)
        end
      end
    end
  end
end
