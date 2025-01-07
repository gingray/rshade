# frozen_string_literal: true

require 'pry'
require 'bundler/setup'
require 'rshade'
require 'test_formatter'

# require all fixtures
Dir["#{File.dirname(__FILE__)}/fixture/*.rb"].sort.each { |file| require file }

Bundler.require(:test, :development)

RSPEC_ROOT = File.dirname __FILE__

module Helpers
  def file_fixture_read(path)
    absolute_path = File.join(RSPEC_ROOT, 'fixture', path)
    File.read(absolute_path)
  end

  def spec_store_path
    File.join(RSPEC_ROOT, 'store')
  end

  def create_source_node(hash, parent = nil)
    result = RShade::Event.new(parent)
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
  config.example_status_persistence_file_path = '.rspec_status'

  # Disable RSpec exposing methods globally on `Module` and `main`
  config.disable_monkey_patching!

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end
  config.before(:suite) do
    store_dir = File.join(RSPEC_ROOT, 'store')
    FileUtils.mkdir_p(store_dir)
    # be careful wipe all entire dir
    FileUtils.rm_rf(Dir.glob(File.join(store_dir, '/**.*')))
  end
end
