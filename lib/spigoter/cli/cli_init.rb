module Spigoter
    module CLI
        def self.init
            return Init::init
        end
        module Init
            def self.init
                return lambda do |opts|
                    main(opts)
                end
            end
            def self.main(opts = {})
                plugins, spigoter = false, false
                plugins = true if File.exist?('plugins.yml')
                spigoter = true if File.exist?('spigoter.yml')

                if(spigoter)
                    Log.warn "spigoter.yml alredy exists"
                else
                    generate_spigoter
                end
                if(plugins)
                    Log.warn "plugins.yml alredy exists"
                else
                    generate_plugins
                end
            end
            def self.generate_spigoter
                config = {
                    'Spigoter' => {
                        'build_dir' => 'build',
                        'plugins_dir' => 'plugins',
                        'javaparams' => '-Xms1G -Xmx2G',
                        'spigot_version' => Spigoter::SPIGOT_VERSION
                    }
                }
                yml = File.open("spigoter.yml", 'wb')
                yml.write(config.to_yaml)
                yml.close
            end
            def self.generate_plugins
                plugins = {'Plugins' => {}}
                default_data = {
                    'type_replace' => "whet",
                    'url_replace' => "lulz"
                }
                if Dir.exist?('plugins')
                    Dir['plugins/*.jar'].each do |plg|
                        plugins['Plugins'][File.basename(plg).gsub(/.jar/, "")] = {
                            'type_replace' => "#{plg}",
                            'url_replace' => "lulz",
                        }
                    end
                else
                    plugins['Plugins']['Test'] = default_data
                end
                plugins = plugins.to_yaml
                plugins = plugins.gsub(/type_replace:.+/, "# type: {curse|devbukkit|....}")
                plugins = plugins.gsub(/url_replace:.+/, "# url: http://something.com")
                plugins = plugins.gsub(/Test:/, "# Plugin1:")
                yml = File.open("plugins.yml", 'wb')
                yml.write(plugins)
                yml.close
            end
        end
    end
end
