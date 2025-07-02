# frozen_string_literal: true

module RShade
  module Patcher
    class ObjectPatcher
      def patch(object, method, type = :inst, &action_block)
        module_name = "RShadeDynModule#{demodulize(object.to_s)}#{method}"
        m = Object.const_set(module_name, Module.new)
        m.define_singleton_method(:prepended) do |base|
          original_method = "#{method}_original"
          if type == :inst
            base.alias_method(original_method, method)
          else
            base.singleton_class.alias_method(original_method, method)
          end
          method_definition = type == :class ? 'define_singleton_method' : 'define_method'
          base.send(method_definition, method) do |*args, **kwargs, &block|
            action_block.call(*args, **kwargs)
            result = send(original_method, *args, **kwargs, &block)

            result
          end
        end
        object.prepend(m)
      end

      private

      def demodulize(path)
        path = path.to_s
        if (i = path.rindex('::'))
          path[(i + 2), path.length]
        else
          path
        end
      end
    end
  end
end
