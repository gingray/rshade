require 'date'
module RShade
  class EventSerializer < Base
    attr_reader :evt, :level
    SERIALIZE_CLASSES = [NilClass, TrueClass, FalseClass, Numeric, Time, Date, String, Symbol, Array]
    def initialize(evt, level)
      @evt = evt
      @level = level
    end

    def call
      { level: @level, path: evt.path, lineno: evt.lineno, klass: evt.defined_class, method_name: evt.method_id, vars: process_locals(evt) }
    end

    def process_locals(evt)
      vars = {}
      evt.binding.local_variables.each do |var|
        local_var = evt.binding.local_variable_get var
        if SERIALIZE_CLASSES.any? { |klass| local_var.is_a?(klass) }
          vars[var] = local_var
        elsif local_var.is_a?(Hash)
          vars[var] = shallow_copy_of_hash(local_var)
        else
          class_name =  local_var.is_a?(Class) ? local_var.to_s : local_var.class.to_s
          vars[var] = "FILTERED[#{class_name}]"
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