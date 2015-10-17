ignore %r{^examples/.+/bin/},
       /.*\.nupkg/,
       %r{^examples/.+/project.lock.json}

guard 'rake', task: 'default' do
  watch 'Rakefile'
  watch '.rspec'
  watch '.rubocop.yml'
  watch '.reek'
  watch %r{^lib/}
  watch %r{^spec/}
  watch %r{^examples/}
end
