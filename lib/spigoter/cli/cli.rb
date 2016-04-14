module Spigoter
  # This module encloses all CLI commands.
  # @author Daniel Ramos Acosta <danielramosacosta@hotmail.com>
  module CLI
    def self.run(command, opts = {})
      Run.new.task[command].call(opts)
    end

    # Class for running tasks.
    # @author Daniel Ramos Acosta <danielramosacosta@hotmail.com>
    class Run
      attr_reader :task
      def initialize
        @task = {
          'update' => Spigoter::CLI.update,
          'compile' => Spigoter::CLI.compile,
          'start' => Spigoter::CLI.start,
          'init' => Spigoter::CLI.init
        }
      end
    end
  end
end
