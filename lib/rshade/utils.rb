# frozen_string_literal: true

module RShade
  module Utils
    RUBY_VERSION_PATTERN = /ruby-[0-9.]*/.freeze

    def self.store_dir
      File.expand_path('../../tmp', __dir__)
    end

    def self.root_dir
      @root_dir ||= File.expand_path('../../', __dir__)
    end

    def self.default_excluded_path
      [ENV['GEM_PATH'].split(':'), RUBY_VERSION_PATTERN, /internal/, %r{/gems/}].flatten.compact
    end
  end
end
