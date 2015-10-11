$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
require 'pathname'
require 'open3'
require 'rake/dnx'

def example_project_dir(project)
  Pathname.new(__FILE__) + '../../examples' + project
end

def rake(*args, quiet: false)
  # we're buffering the whole output which is slow and dumb, but it should be
  # fine for now since we don't expect crazy long ouputs
  stdout, stderr, status = Open3.capture3 'rake', *args

  unless quiet && status.success?
    $stdout.write stdout
    $stderr.write stderr
  end

  # rubocop:disable Style/GuardClause
  unless status.success?
    fail StandardError,
         "Failed to run '#{rake} #{args.join ' '}', error_code=#{status}"
  end
end
