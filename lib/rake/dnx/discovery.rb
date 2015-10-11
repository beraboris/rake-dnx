require 'English'
require 'rake'
require 'json'
require 'pathname'
require 'rake/dnx/errors'
require 'rake/dnx/project'

module Rake
  module Dnx
    # Utilities that discover projects and generate tasks for them
    module Discovery
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

      private

      def discover_gobal
        define_command_task :dnu, :restore

        projects = projects_in_global
        generate_tasks_for_projects projects

        %w(build pack).each do |command|
          define_aggregate_task 'dnu', command, projects
        end

        aggregate_commands(projects).each do |command, command_projects|
          define_aggregate_task 'dnx', command, command_projects
        end
      end

      def generate_tasks_for_projects(projects)
        projects.each do |project|
          %w(build pack publish).each do |command|
            define_command_task :dnu, command, project: project
          end

          ['run', *project.commands].each do |command|
            define_command_task :dnx, command, project: project
          end
        end
      end

      def define_aggregate_task(command, sub_command, projects)
        dependencies = projects.map { |p| command_task_name sub_command, p }

        describe_aggregate_task command, sub_command
        Rake::Task.define_task sub_command => dependencies.to_a
      end

      def aggregate_commands(projects)
        commands = Hash.new { [] }

        projects.each do |project|
          project.commands.each do |command|
            commands[command] += [project]
          end
        end

        commands
      end

      def discover_project
        %w(restore build pack publish).each do |command|
          define_command_task :dnu, command
        end

        define_command_task :dnx, :run
        define_tasks_for_project_commands
      end

      def define_command_task(command, sub_command, project: nil)
        describe_task command, sub_command, project
        Rake::Task.define_task command_task_name sub_command, project do
          public_send command, sub_command, project: project
        end
      end

      def define_tasks_for_project_commands
        project = Project.parse Pathname.new '.'
        project.commands.each do |command|
          define_command_task :dnx, command
        end
      end

      def projects_in_global
        global_contents = Pathname.new('global.json').read
        project_dirs = JSON.parse(global_contents)['projects'] || {}
        project_dirs
          .flat_map { |dir| Pathname.new(dir).children }
          .select { |dir| Project.exist? dir }
          .map { |dir| Project.parse dir }
      end

      def command_task_name(command, project = nil)
        if project
          "#{project.name}:#{command}"
        else
          command
        end
      end

      def describe_aggregate_task(command, sub_command)
        Rake.application.last_description = \
          "Run #{command} #{sub_command} for all projects"
      end

      def describe_task(command, sub_command, project = nil)
        if project
          Rake.application.last_description = \
            "Run #{command} #{sub_command} for #{project.name}"
        else
          Rake.application.last_description = \
            "Run #{command} #{sub_command}"
        end
      end
    end
  end
end
