# frozen_string_literal: true

lib = File.expand_path('lib', __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'truework/version'

Gem::Specification.new do |spec|
  spec.name          = 'truework'
  spec.version       = Truework::VERSION
  spec.required_ruby_version = '>= 2.4'
  spec.authors       = ['Truework']
  spec.email         = ['ruby-sdk@truework.com']

  spec.summary       = 'Ruby bindings for the Truework API.'
  spec.homepage      = 'https://www.github.com/truework/truework-sdk-ruby'
  spec.license       = 'MIT'

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_dependency 'dry-struct', '~> 1.2'

  spec.add_development_dependency 'bundler', '~> 2.1'
  spec.add_development_dependency 'rake', '~> 10.0'
  spec.add_development_dependency 'rspec', '~> 3.0'
  spec.add_development_dependency 'rubocop', '~> 0.79'
  spec.add_development_dependency 'webmock', '~> 3.8'
end
