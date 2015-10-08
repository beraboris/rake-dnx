require 'rake'
require 'json'
require 'pathname'
require 'rake/dnx/version'
require 'rake/dnx/project'
require 'English'

module Rake
  # Rake DNX si a set of helpers that let you discover and run your DNX (.NET
  # Execution Envrionment) commands from one place easily.
  module Dnx
    # Represents a failure when running the `dnx` command
    class CommandError < RuntimeError
      attr_reader :exit_code, :command, :sub_command, :params

      def initialize(command, exit_code, sub_command, params = {})
        @exit_code = exit_code
        @command = command
        @sub_command = sub_command
        @params = params

        super "Failed to run '#{command} #{sub_command}' with '\
          'params=#{params} (exit_code=#{exit_code})"
      end
    end

    # Represents that the dnx command doesn't exist
    class CommandNotFoundError < RuntimeError
      attr_reader :command

      def initialize(command)
        super "Failed to find the #{command} command. Make sure it's installed."
      end
    end

    # Represents a failure to discover dnx projects
    class DiscoveryError < RuntimeError; end

    # Calls the `dnx` command
    def dnx(command, **options)
      run_command 'dnx', command, **options
    end
    module_function :dnx

    # Calls the `dnu` command
    def dnu(command, **options)
      run_command 'dnu', command, **options
    end
    module_function :dnu

    # Finds `global.json` and `project.json` and generates all the tasks
    # applicable to those
    def dnx_discover
      if Pathname.new('global.json').exist?
        discover_gobal
      elsif Pathname.new('project.json').exist?
        discover_project
      else
        fail DiscoveryError,
             'Could not find global.json or project.json in the current ' \
             'directory. Is this a DNX project?'
      end
    end
    module_function :dnx_discover

    private

    def discover_gobal
      generate_dnu_task 'restore'

      projects = projects_in_global
      projects.each do |project|
        %w(build pack publish).each do |command|
          generate_dnu_task command, project: project.name
        end

        ['run', *project.commands].each do |command|
          generate_dnx_task command, project: project.name
        end
      end

      %w(build pack).each do |command|
        dependencies = projects.map { |p| "#{p.name}:#{command}" }.to_a
        Rake::Task.define_task command, dependencies
      end

      aggregate_commands(projects).each do |command, dependencies|
        Rake::Task.define_task command, dependencies
      end
    end
    module_function :discover_gobal

    def aggregate_commands(projects)
      commands = Hash.new { [] }

      projects.each do |project|
        project.commands.each do |command|
          commands[command] += ["#{project.name}:#{command}"]
        end
      end

      commands
    end
    module_function :aggregate_commands

    def discover_project
      %w(restore build pack publish).each do |command|
        generate_dnu_task command
      end

      generate_dnx_task :run
      generate_dnx_tasks_for_project
    end
    module_function :discover_project

    def generate_dnu_task(command, project: nil)
      task_name = project ? "#{project}:#{command}" : command
      Rake::Task.define_task task_name do
        dnu command, project: project
      end
    end
    module_function :generate_dnu_task

    def generate_dnx_task(command, project: nil)
      task_name = project ? "#{project}:#{command}" : command
      Rake::Task.define_task task_name do
        dnx command
      end
    end
    module_function :generate_dnx_task

    def generate_dnx_tasks_for_project
      project = Project.parse Pathname.new '.'
      project.commands.each do |command|
        generate_dnx_task command
      end
    end
    module_function :generate_dnx_tasks_for_project

    def projects_in_global
      global_contents = Pathname.new('global.json').read
      project_dirs = JSON.parse(global_contents)['projects'] || {}
      project_dirs
        .flat_map { |dir| Pathname.new(dir).children }
        .select { |dir| Project.exist? dir }
        .map { |dir| Project.parse dir }
    end
    module_function :projects_in_global

    # :reek:NilCheck
    def run_command(command, sub_command, **options)
      shell_options = options.flat_map { |name, value| ["--#{name}", value] }
      res = system command, *shell_options, sub_command

      case res
      when false
        fail CommandError.new(command, $CHILD_STATUS, sub_command)
      when nil
        fail CommandNotFoundError, command
      end
    end
    module_function :run_command
  end
end
