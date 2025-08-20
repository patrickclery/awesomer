# frozen_string_literal: true

require_relative "lib/awesomer/version"

Gem::Specification.new do |spec|
  spec.name = "awesomer"
  spec.version = Awesomer::VERSION
  spec.authors = [ "Your Name" ]
  spec.email = [ "your.email@example.com" ]

  spec.summary = "CLI utility for processing GitHub Awesome Lists"
  spec.description = "A command-line tool for fetching, parsing, and processing GitHub Awesome Lists " \
                     "repositories with statistics"
  spec.homepage = "https://github.com/yourusername/awesomer"
  spec.license = "MIT"
  spec.required_ruby_version = ">= 3.1.0"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = spec.homepage
  spec.metadata["changelog_uri"] = "#{spec.homepage}/blob/main/CHANGELOG.md"

  # Specify which files should be added to the gem when it is released.
  spec.files = Dir.chdir(__dir__) do
    `git ls-files -z`.split("\x0").reject do |f|
      (File.expand_path(f) == __FILE__) ||
        f.start_with?(*%w[bin/ test/ spec/ features/ .git .circleci appveyor Gemfile])
    end
  end
  spec.bindir = "bin"
  spec.executables = [ "awesomer" ]
  spec.require_paths = [ "lib" ]

  # Runtime dependencies
  spec.add_dependency "thor", "~> 1.3"
  spec.add_dependency "dotenv", "~> 3.0"
  spec.add_dependency "dry-monads", "~> 1.6"
  spec.add_dependency "octokit", "~> 9.0"

  # Development dependencies (optional, if you want to use bundler for development)
  spec.add_development_dependency "rake", "~> 13.0"
  spec.add_development_dependency "rspec", "~> 3.0"
  spec.add_development_dependency "rubocop", "~> 1.21"
end
