require 'json'

module Rake
  module Dnx
    # A Dnx project
    class Project
      attr_reader :name, :commands

      def self.exist?(dir)
        dir.exist? && (dir + 'project.json').exist?
      end

      def self.parse(dir)
        commands = JSON.parse((dir + 'project.json').read)['commands'] || {}
        new dir.basename.to_s, commands.keys
      end

      def initialize(name, commands)
        @name = name
        @commands = commands
      end
    end
  end
end
