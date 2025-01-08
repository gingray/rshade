# frozen_string_literal: true

class Object
  # rubocop:disable Metrics/MethodLength
  def reveal(method_name = nil, **opts, &block)
    if method_name
      @__cache_rshade_reveal ||= {}
      config = opts.fetch(:config, ::RShade::Config::EventStore.default)
      @__cache_rshade_reveal[method_name] = config
      instance_eval do
        def method_added(name)
          super
          return unless @__cache_rshade_reveal[name]

          if @__reveal_rewrite
            @__reveal_rewrite = false
            return
          end
          @__reveal_rewrite = true
          config = @__cache_rshade_reveal[name]
          origin_method = instance_method(name)
          define_method(name) do |*args, &fn|
            val = nil
            trace = ::RShade::Trace.reveal(config: config) do
              val = origin_method.bind(self).call(*args, &fn)
            end
            trace.show
            val
          end
        end
      end
    else
      trace = ::RShade::Trace.reveal do
        block.call if block_given?
      end
      trace.show
    end
  end
  # rubocop:enable Metrics/MethodLength
end
