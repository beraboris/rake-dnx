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
        generate_dnu_task 'restore'

        projects = projects_in_global
        projects.each do |project|
          %w(build pack publish).each do |command|
            generate_dnu_task command, project: project
          end

          ['run', *project.commands].each do |command|
            generate_dnx_task command, project: project
          end
        end

        %w(build pack).each do |command|
          dependencies = projects.map { |p| command_task_name command, p }.to_a
          Rake::Task.define_task command, dependencies
        end

        aggregate_commands(projects).each do |command, dependencies|
          Rake::Task.define_task command, dependencies
        end
      end

      def aggregate_commands(projects)
        commands = Hash.new { [] }

        projects.each do |project|
          project.commands.each do |command|
            commands[command] += [command_task_name(command, project)]
          end
        end

        commands
      end

      def discover_project
        %w(restore build pack publish).each do |command|
          generate_dnu_task command
        end

        generate_dnx_task :run
        generate_dnx_tasks_for_project
      end

      def generate_dnu_task(command, project: nil)
        Rake::Task.define_task command_task_name command, project do
          dnu command, project: project
        end
      end

      def generate_dnx_task(command, project: nil)
        Rake::Task.define_task command_task_name command, project do
          dnx command
        end
      end

      def generate_dnx_tasks_for_project
        project = Project.parse Pathname.new '.'
        project.commands.each do |command|
          generate_dnx_task command
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
    end
  end
end
