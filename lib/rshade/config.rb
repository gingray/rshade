require 'set'

module RShade
  class Config

    def self.default
      ::RShade::Config::Store.new(::RShade::Filter::Default.create, ::RShade::Formatter::Stdout)
    end

    def self.store_dir
      File.expand_path('../../tmp', __dir__)
    end

    def self.root_dir
      @root_dir ||= File.expand_path('../../', __dir__)
    end
  end
end
