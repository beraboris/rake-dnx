require 'rake/dnx/version'
require 'English'

module Rake
  # Rake DNX si a set of helpers that let you discover and run your DNX (.NET
  # Execution Envrionment) commands from one place easily.
  module Dnx
    # Represents a failure when running the `dnx` command
    class DnxError < RuntimeError
      attr_reader :exit_code, :command, :params

      def initialize(exit_code, command, params = {})
        @exit_code = exit_code
        @command = command
        @params = params

        super "Failed to run 'dnx #{command}' with param=#{params} ' \
          '(exit_code=#{exit_code})"
      end
    end

    # Represents that the dnx command doesn't exist
    class DnxNotFoundError < RuntimeError
      def initialize
        super 'Failed to find the dnx command. Make sure it is installed'
      end
    end

    # Calls the `dnx` command
    #
    # Ignoring :reek:NilCheck since it's a part of `system` and has a special
    #   meaning
    def dnx(command, project: nil)
      options = []
      options += ['--project', project] if project
      res = system 'dnx', *options, command

      case res
      when false
        fail DnxError.new($CHILD_STATUS, command)
      when nil
        fail DnxNotFoundError
      end
    end
    module_function :dnx
  end
end
