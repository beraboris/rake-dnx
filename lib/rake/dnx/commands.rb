require 'rake/dnx/errors'

module Rake
  module Dnx
    # Command wrappers for `dnx` and `dnu`
    module Commands
      # Calls the `dnx` command
      def dnx(command, project: nil)
        if project
          run_command 'dnx', command.to_s, '-p', project.name
        else
          run_command 'dnx', command.to_s
        end
      end

      # Calls the `dnu` command
      def dnu(command, project: nil)
        if project
          Dir.chdir project.path do
            run_command 'dnu', command.to_s
          end
        else
          run_command 'dnu', command.to_s
        end
      end

      private

      def run_command(command, sub_command, *args)
        res = system command, *args, sub_command

        case res
        when false
          fail CommandError.new(command, $CHILD_STATUS, sub_command)
        when nil
          fail CommandNotFoundError, command
        end
      end
    end
  end
end
