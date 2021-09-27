# frozen_string_literal: true

require_relative "lib/memolog/version"

Gem::Specification.new do |spec|
  spec.name = "memolog"
  spec.version = Memolog::VERSION
  spec.authors = ["Stepan Kirushkin"]
  spec.email = ["stepan.kirushkin@gmail.com"]

  spec.summary = "In-memory logger for exceptions."
  spec.description = <<-TXT
    Memolog is an in-memory logger, which extend any other logger.
    Designed to work with Sentry.
    It adds `memolog` extra section to Sentry errors.
  TXT

  spec.homepage = "https://github.com/skirushkin/memolog"
  spec.license = "MIT"
  spec.required_ruby_version = ">= 2.5.0"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = spec.homepage
  spec.metadata["changelog_uri"] = spec.homepage

  spec.files = `git ls-files -z`.split("\x0").reject { |f| f.include?("spec") }
  spec.require_paths = ["lib"]

  spec.add_dependency "logger"
  spec.add_dependency "securerandom"

  spec.add_development_dependency "pry"
  spec.add_development_dependency "rails"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "rspec"
  spec.add_development_dependency "rubocop-config-umbrellio"
  spec.add_development_dependency "sentry-ruby"
  spec.add_development_dependency "sidekiq"
end
