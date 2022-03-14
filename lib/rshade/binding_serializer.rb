require 'date'
module RShade
  class BindingSerializer
    SERIALIZE_CLASSES = [NilClass, TrueClass, FalseClass, Numeric, Time, Date, String, Symbol, Array]
    
    def initialize(opts={})
    end

    def call(binding)
      vars = {}
      binding.local_variables.each do |var_name|
        local_var = binding.local_variable_get var_name
        if SERIALIZE_CLASSES.any? { |klass| local_var.is_a?(klass) }
          vars[var_name] = local_var
        elsif local_var.is_a?(Hash)
          copy = shallow_copy_of_hash(local_var)
          vars[var_name] = copy
        else
          class_name =  local_var.is_a?(Class) ? local_var.to_s : local_var.class.to_s
          vars[var_name] = class_name
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