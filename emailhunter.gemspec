# frozen_string_literal: true

# Use require_relative to load the version file
require_relative 'lib/email_hunter/version'

Gem::Specification.new do |spec|
  spec.name          = 'emailhunter'
  spec.version       = EmailHunter::VERSION
  spec.authors       = ['Davide Santangelo']
  spec.email         = ['davide.santangelo@gmail.com']

  spec.summary       = 'A tiny Ruby wrapper around the Hunter.io API'
  spec.description   = <<~DESC
    EmailHunter is a minimalistic Ruby wrapper for the Hunter.io API.
    It provides a straightforward interface to integrate Hunter.io's
    email discovery capabilities into your sales and marketing workflows.
  DESC
  spec.license       = 'MIT'

  # Adding additional metadata improves discoverability
  spec.homepage      = 'https://github.com/davidesantangelo/emailhunter'
  spec.metadata      = {
    'source_code_uri' => 'https://github.com/davidesantangelo/emailhunter'
  }

  # Automatically include all version-controlled files except tests and specs
  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f =~ %r{^(test|spec|features)/} }
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  # Development dependencies
  spec.add_development_dependency 'bundler', '~> 2.1'
  spec.add_development_dependency 'rake', '~> 10.0'
  spec.add_development_dependency 'rspec'
  spec.add_development_dependency 'typhoeus'
  spec.add_development_dependency 'vcr'

  spec.required_ruby_version = '>= 3.0.0'

  # Runtime dependencies
  spec.add_dependency 'faraday'
  spec.add_dependency 'json'
end
