module Rake
  module Dnx
    # Represents a failure when running the `dnx` command
    class CommandError < RuntimeError
      attr_reader :exit_code, :command, :sub_command, :params

      def initialize(command, exit_code, sub_command, params = {})
        @exit_code = exit_code
        @command = command
        @sub_command = sub_command
        @params = params

        super "Failed to run '#{command} #{sub_command}' with " \
          "params=#{params} (exit_code=#{exit_code})"
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
  end
end
