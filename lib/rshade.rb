require 'colorized_string'
require 'erb'
require 'rshade/config'
require 'rshade/config/store'
require 'rshade/base'
require 'rshade/event_serializer'
require 'rshade/filter/base'
require 'rshade/filter/include_path_filter'
require 'rshade/filter/exclude_path_filter'
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
  APP_TRACE = :app_trace
  FULL_TRACE = :full_trace

  class << self
    attr_writer :config

    def config
      @config ||= Config.new
    end

    def configure
      yield configuration
    end
  end
end
