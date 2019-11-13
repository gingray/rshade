require 'colorize'
require 'rshade/source'
require 'rshade/tree'
require 'rshade/source_node'
require 'rshade/trace'
require 'rshade/rspec'
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
