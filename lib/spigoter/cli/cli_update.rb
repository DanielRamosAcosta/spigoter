module Spigoter
    module CLI
        def self.update
            return Update::update
        end
        module Update
            def self.update
                return lambda do |opts={}|
                    main(opts)
                end
            end
            def self.main(opts={})
                Log.info "Updating!"

                unless File.exist?('plugins.yml')
                    Log.error "plugins.yml doesn't exists, please, create one (you can use spigoter init)"
                    exit(1)
                end

                unless Dir.exist?('plugins')
                    Log.error "plugins directory doesn't exists, please, create it"
                    exit(1)
                end

                #TODO: change utils to remove underscore
                _, plugins_data = Spigoter::Utils.get_plugins(opts)

                plugins_data.each do |name, data|
                    Log.info "Updating plugin: #{name}"

                    if (Spigoter::Plugin.list[data[:type].to_sym].nil?)
                        Log.error "Plugin type #{data[:type]} doesn't exists!"
                        exit(1)
                    end

                    begin
                        objeto = Spigoter::Plugin.list[data[:type].to_sym].new(data[:url])
                    rescue => e
                        Log.error e.message
                    end

                    if (!objeto.nil?)
                        File.open("plugins/#{name}.jar", 'w+b') do |f|
                            f.write(objeto.file)
                        end
                    end
                end
            end
        end
    end
end
