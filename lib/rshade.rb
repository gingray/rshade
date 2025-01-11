# frozen_string_literal: true

require 'colorized_string'
require 'binding_of_caller'
require 'erb'
require 'weakref'
require 'observer'
require 'json'
require 'singleton'

require 'rshade/serializer/traversal'
require 'rshade/event_tree'
require 'rshade/event_processor'
require 'rshade/event_observer'
require 'rshade/trace_observable'
require 'rshade/filter/abstract_filter'
require 'rshade/filter/filter_builder'
require 'rshade/filter/filter_composition'
require 'rshade/filter/include_path_filter'
require 'rshade/filter/exclude_path_filter'
require 'rshade/filter/variable_filter'
require 'rshade/filter/default'

require 'rshade/formatter/trace/string'
require 'rshade/formatter/trace/json'
require 'rshade/formatter/trace/html'
require 'rshade/formatter/trace/stdout'

require 'rshade/formatter/stack/string'
require 'rshade/formatter/stack/stdout'
require 'rshade/formatter/stack/json'

require 'rshade/utils'
require 'rshade/config/event_store'
require 'rshade/config/stack_store'
require 'rshade/config/registry'

require 'rshade/event'
require 'rshade/trace'
require 'rshade/stack'
require 'rshade/stack_frame'
require 'rshade/rspec/rspec'
require 'rshade/core_extensions/object/reveal'
require 'rshade/version'

module RShade
end
