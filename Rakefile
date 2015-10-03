require 'bundler/gem_tasks'
require 'rspec/core/rake_task'
require 'rubocop/rake_task'
require 'reek/rake/task'

RSpec::Core::RakeTask.new(:spec)

task default: [:spec, :lint]

desc 'Run linters to ensure code quality'
task lint: [:rubocop, :reek]

desc 'Run rubocop linter'
task RuboCop::RakeTask.new :rubocop do |t|
  t.patterns = ['lib/**/*.rb', 'spec/**/*.rb']
  t.fail_on_error = false
end

task Reek::Rake::Task.new :reek do |t|
  t.source_files = ['lib/**/*.rb', 'spec/**/*.rb']
  t.fail_on_error = false
end
