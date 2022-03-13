require 'colorized_string'
require 'erb'
require 'weakref'
require 'rshade/config'
require 'rshade/config/store'
require 'rshade/event_serializer'
require 'rshade/filter/abstract_filter'
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
require 'rshade/event_store'
require 'rshade/trace'
require 'rshade/rspec/rspec'
require 'rshade/version'


module RShade
end
