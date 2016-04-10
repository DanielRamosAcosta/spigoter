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

                list, plugins_data = get_plugins(opts)
                puts list
                puts plugins_data

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
        end
    end
end
