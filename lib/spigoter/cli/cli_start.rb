module Spigoter
  # This module encloses all CLI commands.
  # @author Daniel Ramos Acosta <danielramosacosta@hotmail.com>
  module CLI
    def self.start
      Start.start
    end
    # Module for starting the server.
    # @author Daniel Ramos Acosta <danielramosacosta@hotmail.com>
    module Start
      def self.start
        ->(opts = {}) { main(opts) }
      end

      def self.main(opts)
        Log.info 'Starting the server!'
        dependencies
        opts = {}
        begin
          opts = Spigoter::Utils.fill_opts_config
        rescue => e
          Log.error e.message
          exit(1)
        end
        system("java #{opts[:javaparms]} -jar spigot.jar")
      end

      def self.dependencies
        if Spigoter::Utils.which('java').nil?
          Log.error "You don't have java in PATH"
          exit(1)
        end
      end
    end
  end
end
