# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'spigoter/version'

Gem::Specification.new do |spec|
  spec.name          = "spigoter"
  spec.version       = Spigoter::VERSION
  spec.authors       = ["Daniel Ramos"]
  spec.email         = ["danielramosacosta@hotmail.com"]

  spec.summary       = %q{A CLI utility for Minecraft servers}
  spec.description   = %q{A CLI utility for Minecraft servers}
  spec.homepage      = "https://github.com/DanielRamosAcosta/spigoter"
  spec.license       = "MIT"

  spec.required_ruby_version = '>= 2.2.4'

  # Prevent pushing this gem to RubyGems.org by setting 'allowed_push_host', or
  # delete this section to allow pushing this gem to any host.
  if spec.respond_to?(:metadata)
    spec.metadata['allowed_push_host'] = "https://rubygems.org"
  else
    raise "RubyGems 2.0 or newer is required to protect against public gem pushes."
  end

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.11"
  spec.add_development_dependency "rake", "~> 11.1"
  spec.add_development_dependency "rspec", "~> 3.4"
  spec.add_development_dependency "guard", "~> 2.13"
  spec.add_development_dependency "guard-rspec", "~> 4.6"
  spec.add_development_dependency "guard-bundler", "~> 2.1"
  spec.add_development_dependency "coveralls", "~> 0.8"
  spec.add_development_dependency "yard", "~> 0.8"
  spec.add_development_dependency "codeclimate-test-reporter", "~> 0.5.0"
  spec.add_development_dependency "rubocop", "~> 0.39.0"

  spec.add_runtime_dependency "logging", "~> 2.1"
end
