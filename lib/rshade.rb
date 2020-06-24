require 'colorize'
require 'rshade/configuration'
require 'rshade/base'
require 'rshade/filter/app_filter'
require 'rshade/formatter/string'
require 'rshade/formatter/json'
require 'rshade/formatter/stdout'
require 'rshade/formatter/http'
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
      @config ||= Configuration.new
    end

    def configure
      yield configuration
    end
  end
end
