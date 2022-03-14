require 'date'
module RShade
  class BindingSerializer
    SERIALIZE_CLASSES = [NilClass, TrueClass, FalseClass, Numeric, Time, Date, String, Symbol, Array]
    
    def initialize(opts={})
    end

    def call(trace_binding)
      vars = {}
      trace_binding.each do |name, value|
        if SERIALIZE_CLASSES.any? { |klass| value.is_a?(klass) }
          vars[name] = value
        elsif value.is_a?(Hash)
          copy = shallow_copy_of_hash(value)
          vars[name] = copy
        else
          class_name =  value.is_a?(Class) ? value.to_s : value.class.to_s
          vars[name] = class_name
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