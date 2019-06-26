require "bundler/setup"
require "rshade"
require 'fixture/test'
Bundler.require(:test, :development)

RSPEC_ROOT = File.dirname __FILE__

module Helpers
  def file_fixture_read(path)
    absolute_path = File.join(RSPEC_ROOT,'fixture', path)
    File.read(absolute_path)
  end

  def create_source_node(hash, parent = nil)
    result = RShade::SourceNode.new(parent)
    value = RShade::SourceValue.new
    hash = {}
    hash.each do |k, v|
      hash[:level] = v if k == 'level'
      hash[:path] = v if k == 'path'
      next unless k == 'nodes'
      
      v.each do |node|
        result.nodes << create_source_node(node, result)
      end
    end
    value.hash = hash
    result.value = value
    result
  end
end

RSpec.configure do |config|
  config.include Helpers
  # Enable flags like --only-failures and --next-failure
  config.example_status_persistence_file_path = ".rspec_status"

  # Disable RSpec exposing methods globally on `Module` and `main`
  config.disable_monkey_patching!

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end
end
