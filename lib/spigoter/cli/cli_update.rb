module Spigoter
    module CLI
        def self.update
            return Update::update
        end
        module Update
            def self.update
                return lambda do |opts|
                    main(opts)
                end
            end
            def self.main(opts)
                Log.info "Updating!"

                list, plugins_data = get_plugins(opts)

                list.each do |plugin|
                    begin
                        Log.info "Starting to download #{plugin}"
                        hash = Plugins.get_plugin(plugin, plugins_data[plugin])
                        plugin_file = File.open("plugins/#{plugin}.jar", 'wb')
                        plugin_file.write(hash[:file])
                        Log.info "#{plugin} was downloaded correctly"
                    rescue
                        Log.error "Unkown source #{plugins_data[plugin]['type']}"
                    end
                end
            end

            def self.get_plugins(opts)
                unless File.exist?('plugins.yml')
                    Log.error "plugins.yml doesn't exists, please, create one (you can use spigoter init)"
                    exit(1)
                end
                unless Dir.exist?('plugins')
                    Log.error "plugins directory doesn't exists, please, create it"
                    exit(1)
                end

                file = File.read('plugins.yml')
                plugins_data = YAML.load(file)
                list = plugins_data.keys # by default, update all plugins
                unless opts[:list].nil?
                    unless opts[:list].empty?
                        list = opts[:list] # If a list cames in input, use it.
                    end
                end

                return list, plugins_data
            end
        end
    end
end
