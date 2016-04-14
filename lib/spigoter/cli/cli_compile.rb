module Spigoter
  # This module encloses all CLI commands.
  # @author Daniel Ramos Acosta <danielramosacosta@hotmail.com>
  module CLI
    def self.compile
      Compile.compile
    end
    # Module for compiling Spigot
    # @author Daniel Ramos Acosta <danielramosacosta@hotmail.com>
    module Compile
      def self.compile
        Log.info 'Compiling Spigot!'
        ->(*) { main }
      end

      def self.main(*)
        dependencies
        opts = import_opts

        FileUtils.mkdir_p 'build'
        Dir.chdir('build') do
          download_buildtools
          FileUtils.rm_rf(Dir.glob('spigot*.jar'))
          compile_spigot(opts)
        end

        FileUtils.cp(Dir['build/spigot*.jar'].first, 'spigot.jar')
      end

      def self.dependencies
        if Spigoter::Utils.which('javac').nil? || Spigoter::Utils.which('git').nil?
          Log.error "You don't have javac or git in PATH"
          exit(1)
        end
      end

      def self.import_opts
        Spigoter::Utils.fill_opts_config
      rescue
        Log.error 'There is an error in spigoter.yml'
        exit(1)
      end

      def self.download_buildtools
        unless File.exist?('BuildTools.jar')
          file = Spigoter::Utils.download('https://hub.spigotmc.org/jenkins/job/BuildTools/lastSuccessfulBuild/artifact/target/BuildTools.jar')
          File.open('BuildTools.jar', 'wb').write(file)
        end
      end

      def self.compile_spigot(opts)
        Log.info "Compiling spigot version #{opts[:spigot_version]}"
        exit_status = system("java -jar BuildTools.jar --rev #{opts[:spigot_version]}")

        if exit_status != true
          Log.error 'There was an error while compiling Spigot'
          exit(1)
        end
      end
    end
  end
end
