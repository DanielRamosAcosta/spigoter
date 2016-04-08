module Spigoter
    module CLI
        def self.compile
            return Compile::compile
        end
        module Compile
            def self.compile
                return lambda do |opts|
                    main(opts)
                end
            end
            def self.main(opts = {})
                validate_deps

                begin
                    opts = Spigoter::Utils.fill_opts_config
                rescue
                    Log.error e.message
                    exit(1)
                end

                Log.info "Compiling Spigot!"
                FileUtils.mkdir_p 'build'
                Dir.chdir('build')

                unless File.exist?('BuildTools.jar')
                    file = Spigoter::Utils.download('https://hub.spigotmc.org/jenkins/job/BuildTools/lastSuccessfulBuild/artifact/target/BuildTools.jar')
                    File.open('BuildTools.jar', 'wb').write(file)
                end

                FileUtils.rm_rf(Dir.glob('spigot*.jar'))
                Log.info "Compiling spigot version #{opts[:spigot_version]}"
                exit_status = system("java -jar BuildTools.jar --rev #{opts[:spigot_version]}")

                if(exit_status != true)
                    raise "There was an error while compiling Spigot"
                end

                Dir.chdir('..')
                FileUtils.cp(Dir['build/spigot*.jar'].first, 'spigot.jar')
            end

            def self.validate_deps
                if Spigoter::Utils.which('javac').nil? or Spigoter::Utils.which('git').nil?
                    Log.error "You don't have javac or git in PATH"
                    exit(1)
                end
                return true
            end
        end
    end
end
