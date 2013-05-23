# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'selected_links/version'

Gem::Specification.new do |spec|
  spec.name          = "selected_links"
  spec.version       = SelectedLinks::VERSION
  spec.authors       = ["Kainage"]
  spec.email         = ["kainage@gmail.com"]
  spec.description   = %q{Add a selected class to a link when criteria is matched}
  spec.summary       = %q{Adds a link helper to ActionView to that adds a class of 'selected' when matched to a pattern}
  spec.homepage      = "https://github.com/kainage/selected_links"
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "rspec"

  spec.add_dependency "actionpack"
end
