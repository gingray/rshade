require 'date'
module RShade
  class EventSerializer
    attr_reader :evt, :level
    SERIALIZE_CLASSES = [NilClass, TrueClass, FalseClass, Numeric, Time, Date, String, Symbol, Array]
    
    # more info https://rubyapi.org/3.1/o/tracepoint
    # @param [TracePoint] evt
    # @param [Integer] level
    def initialize(evt, level)
      @evt = evt
      @level = level
    end

    def self.call(*args)
      new(*args).call
    end

    def call
      hash = { level: @level, path: evt.path, lineno: evt.lineno, klass: evt.defined_class, method_name: evt.method_id, vars: process_locals(evt),
        event_type: @evt.event }
      Event.new(hash)
    end

    def process_locals(evt)
      vars = {}
      evt.binding.local_variables.each do |var_name|
        local_var = evt.binding.local_variable_get var_name
        # it's can happen when I pass immutable object (not an issue for Ruby 2.7.1 and higher)
        # https://rubyreferences.github.io/rubychanges/2.7.html#objectspaceweakmap-now-accepts-non-gc-able-objects
        weak_ref = ::WeakRef.new(local_var) rescue nil
        weak_ref = local_var unless weak_ref
        if SERIALIZE_CLASSES.any? { |klass| local_var.is_a?(klass) }
          vars[var_name] = { copy: local_var, weak: weak_ref }
        elsif local_var.is_a?(Hash)
          copy = shallow_copy_of_hash(local_var)
          vars[var_name] = {copy: copy, weak: weak_ref}
        else
          class_name =  local_var.is_a?(Class) ? local_var.to_s : local_var.class.to_s
          vars[var_name] = {copy: class_name, weak_ref: weak_ref }
        end
      end
      vars
    end

    #TODO: work on more efficient way to serialize hash
    def shallow_copy_of_hash(hash)
      {}.tap do |new_hash|
        hash.each do |k,v|
          new_hash[k] = v.to_s
        end
        new_hash
      end
    end
  end
end