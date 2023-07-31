# frozen_string_literal: true

require_relative 'lib/next_gen_images/version'

Gem::Specification.new do |spec|
  spec.name = 'next_gen_images'
  spec.version = NextGenImages::VERSION
  spec.authors = ['JP Balarini']
  spec.email = ['jp@eagerworks.com']

  spec.summary = 'Handle next-gen image formats in your Ruby on Rails project. WebP is currently supported'
  spec.description = 'Adds support for a picture_tag and several utilities to automatically convert images to WebP'
  spec.homepage = 'https://eagerworks.com'
  spec.license = 'MIT'
  spec.required_ruby_version = '>= 2.6.0'

  spec.metadata['allowed_push_host'] = 'https://rubygems.org'

  spec.metadata['homepage_uri'] = spec.homepage
  spec.metadata['source_code_uri'] = 'https://github.com/eagerworks/next_gen_images'
  spec.metadata['rubygems_mfa_required'] = 'true'

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files = Dir.chdir(__dir__) do
    `git ls-files -z`.split("\x0").reject do |f|
      (f == __FILE__) || f.match(%r{\A(?:(?:bin|test|spec|features)/|\.(?:git|travis|circleci)|appveyor)})
    end
  end
  spec.bindir = 'exe'
  spec.executables = spec.files.grep(%r{\Aexe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_runtime_dependency 'rails', '>= 3.1'
  spec.add_runtime_dependency 'webp-ffi', '~> 0.3.1'
  spec.add_development_dependency 'bundler'
  spec.add_development_dependency 'carrierwave', '>= 2.0'
  spec.add_development_dependency 'rspec', '~> 3.12.0'
  spec.add_development_dependency 'rubocop-rspec', '~> 2.17.1'
end
