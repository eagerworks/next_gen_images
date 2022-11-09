# frozen_string_literal: true

require_relative "lib/next_gen_images/version"

Gem::Specification.new do |spec|
  spec.name = "next_gen_images"
  spec.version = NextGenImages::VERSION
  spec.authors = ["JP Balarini"]
  spec.email = ["jp@eagerworks.com"]

  spec.summary = "Handle next-gen image formats in your Ruby on Rails project"
  #spec.description = "TODO: Write a longer description or delete this line."
  spec.homepage = "https://eagerworks.com"
  spec.license = "MIT"
  spec.required_ruby_version = ">= 2.6.0"

  spec.metadata["allowed_push_host"] = "TODO: Set to your gem server 'https://example.com'"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = "https://github.com/eagerworks/next_gen_images"

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files = Dir.chdir(__dir__) do
    `git ls-files -z`.split("\x0").reject do |f|
      (f == __FILE__) || f.match(%r{\A(?:(?:bin|test|spec|features)/|\.(?:git|travis|circleci)|appveyor)})
    end
  end
  spec.bindir = "exe"
  spec.executables = spec.files.grep(%r{\Aexe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency "rack"
  spec.add_development_dependency "rspec", "~> 3.12.0"
end
