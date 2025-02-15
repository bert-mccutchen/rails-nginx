# frozen_string_literal: true

require_relative "lib/rails/nginx/version"

Gem::Specification.new do |spec|
  spec.name = "rails-nginx"
  spec.version = Rails::Nginx::VERSION
  spec.authors = ["Bert McCutchen"]
  spec.email = ["mail@bertm.dev"]

  spec.summary = "Automatic NGINX+SSL configuration for Rails."
  spec.description = "Automatically configure NGINX with SSL upon boot for Rails applications."
  spec.homepage = "https://github.com/bert-mccutchen/rails-nginx"
  spec.license = "MIT"
  spec.required_ruby_version = ">= 3.0.0"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = "https://github.com/bert-mccutchen/rails-nginx"
  spec.metadata["changelog_uri"] = "https://github.com/bert-mccutchen/rails-nginx/blob/main/CHANGELOG.md"
  spec.metadata["rubygems_mfa_required"] = "true"

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files = Dir["CHANGELOG.md", "LICENSE.txt", "README.md", "docs/*", "exe/*", "lib/**/*"]
  spec.bindir = "exe"
  spec.executables = spec.files.grep(%r{\Aexe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency "puma"
  spec.add_dependency "rails"
  spec.add_dependency "ruby-nginx", ">= 1.0.0-beta.4"

  # For more information and examples about making a new gem, check out our
  # guide at: https://bundler.io/guides/creating_gem.html
end
