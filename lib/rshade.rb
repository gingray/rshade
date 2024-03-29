require 'colorized_string'
require 'erb'
require 'weakref'
require 'set'
require 'observer'
require 'rshade/config'
require 'rshade/config/store'
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
require 'rshade/formatter/string'
require 'rshade/formatter/json'
require 'rshade/formatter/file'
require 'rshade/formatter/html'
require 'rshade/formatter/stdout'
require 'rshade/event'
require 'rshade/trace'
require 'rshade/rspec/rspec'
require 'rshade/version'

module RShade
end
