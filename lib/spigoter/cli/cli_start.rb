module Spigoter
    module CLI
        def self.start
            return Start::start
        end
        module Start
            def self.start
                return lambda do |opts|
                    main(opts)
                end
            end
            def self.main(opts)
                opts = {}
                begin
                    opts = Spigoter::Utils.fill_opts_config
                rescue Exception => e
                    Log.error e.message
                    exit(1)
                end

                unless Spigoter::Utils.which('java').nil?
                    Log.info "Starting the server!"
                    system("java #{opts[:javaparms]} -jar spigot.jar")
                else
                    Log.error "You don't have java in PATH"
                    exit(1)
                end
            end
        end
    end
end
