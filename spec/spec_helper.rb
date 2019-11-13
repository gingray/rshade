require 'pry'
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
    hash_val = {}
    hash.each do |k, v|
      hash_val[:level] = v if k == 'level'
      hash_val[:path] = v if k == 'path'
      next unless k == 'nodes'

      v.each do |node|
        result.nodes << create_source_node(node, result)
      end
    end
    result.value = hash
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
