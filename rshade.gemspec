# frozen_string_literal: true

lib = File.expand_path('lib', __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'rshade/version'

Gem::Specification.new do |spec|
  spec.name          = 'rshade'
  spec.version       = RShade::VERSION
  spec.authors       = ['Ivan Lopatin']
  spec.email         = ['gingray.dev@gmail.com']

  spec.summary       = 'https://github.com/gingray/rshade'
  spec.description   = 'https://github.com/gingray/rshade'
  spec.homepage      = 'https://github.com/gingray/rshade'
  spec.license       = 'MIT'

  # Prevent pushing this gem to RubyGems.org. To allow pushes either set the 'allowed_push_host'
  # to allow pushing to a single host or delete this section to allow pushing to any host.
  if spec.respond_to?(:metadata)
    spec.metadata['allowed_push_host'] = 'https://rubygems.org'

    spec.metadata['homepage_uri'] = spec.homepage
    spec.metadata['source_code_uri'] = 'https://github.com/gingray/rshade'
    spec.metadata['changelog_uri'] = 'https://github.com/gingray/rshade/CHANGELOG.md'
  else
    raise 'RubyGems 2.0 or newer is required to protect against ' \
          'public gem pushes.'
  end

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']
  spec.required_ruby_version = '>= 2.7.0'

  spec.add_dependency 'binding_of_caller'
  spec.add_dependency 'colorize'
  spec.add_dependency 'prism'

  spec.metadata['rubygems_mfa_required'] = 'true'
end
