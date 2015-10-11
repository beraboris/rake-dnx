require 'json'

module Rake
  module Dnx
    # A Dnx project
    class Project
      attr_reader :name, :commands, :path

      def self.exist?(dir)
        dir.exist? && (dir + 'project.json').exist?
      end

      def self.parse(dir)
        commands = JSON.parse((dir + 'project.json').read)['commands'] || {}
        new dir.basename.to_s, commands.keys, dir
      end

      def initialize(name, commands, path)
        @name = name
        @commands = commands
        @path = path
      end
    end
  end
end
