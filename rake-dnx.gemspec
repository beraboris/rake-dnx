# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'rake/dnx/version'

Gem::Specification.new do |spec|
  spec.name          = 'rake-dnx'
  spec.version       = Rake::Dnx::VERSION
  spec.authors       = ['Boris Bera']
  spec.email         = ['bboris@rsoft.ca']

  spec.summary = 'Helpers to discover and run DNX (.NET Execution ' \
    'Envrionment) commands with rake.'
  spec.description = 'A set of helpers that allow you to run DNX (.NET ' \
    'Execution Envrionment) tasks accross your different DNX projects. These ' \
    'helpers can automatically dedect your projects and their commands using ' \
    'your global.json file.'
  spec.homepage = 'https://github.com/beraboris/rake-dnx'
  spec.license = 'MIT'

  spec.files = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.require_paths = ['lib']

  spec.add_development_dependency 'bundler', '~> 1.10'
  spec.add_development_dependency 'rake', '~> 10.0'
  spec.add_development_dependency 'rspec', '~> 3.3'
  spec.add_development_dependency 'rubocop', '~> 0.34'
  spec.add_development_dependency 'reek', '~> 3.5'
  spec.add_development_dependency 'guard', '~> 2.13'
  spec.add_development_dependency 'guard-rake', '~> 1.0'
end
