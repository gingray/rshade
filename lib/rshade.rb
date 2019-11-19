require 'colorize'
require 'rshade/configuration'
require 'rshade/code'
require 'rshade/tree'
require 'rshade/event'
require 'rshade/trace'
require 'rshade/rspec/rspec'
require 'rshade/version'


module RShade
  APP_TRACE = :app_trace
  FULL_TRACE = :full_trace

  class << self
    attr_writer :config

    def configuration
      @config ||= Configuration.new
    end

    def configure
      yield configuration
    end
  end
end
