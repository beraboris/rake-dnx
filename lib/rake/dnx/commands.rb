require 'rake/dnx/errors'

module Rake
  module Dnx
    # Command wrappers for `dnx` and `dnu`
    module Commands
      # Calls the `dnx` command
      def dnx(command, **options)
        run_command 'dnx', command.to_s, **options
      end

      # Calls the `dnu` command
      def dnu(command, **options)
        run_command 'dnu', command.to_s, **options
      end

      private

      def run_command(command, sub_command, **options)
        shell_options = options
                        .reject { |_, value| value.nil? }
                        .flat_map { |name, value| ["--#{name}", value] }
        res = system command, *shell_options, sub_command

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
