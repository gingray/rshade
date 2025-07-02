# frozen_string_literal: true

module RShade
  module Rails
    class PatchMiddleware
      def initialize(app, options = {})
        @app = app
        @options = options
        @patched = false
      end

      def call(env)
        unless @patched
          apply_patch(options[:patch])
          @patched = true
        end

        traced_path = @options[:trace_regex]
        if traced_path&.match?(env['REQUEST_PATH'])
          Thread.current[:__patch_rshade_middleware] = true
          puts "RShadePatch #{traced_path} match #{env['REQUEST_PATH']} "
          @app.call(env)
          Thread.current[:__patch_rshade_middleware] = false
        else
          @app.call(env)
        end
      end

      private

      def apply_patch(block)
        return unless block

        block.call
      end
    end
  end
end
