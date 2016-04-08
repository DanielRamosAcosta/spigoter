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
                if(File.exist?('spigoter.yml'))
                    Log.warn "spigoter.yml alredy exists"
                else
                    generate_spigoter
                end
                if(true if File.exist?('plugins.yml'))
                    Log.warn "plugins.yml alredy exists"
                else
                    generate_plugins
                end
            end
            def self.generate_spigoter
                open('spigoter.yml', 'w+') { |f|
                    f << "---\n"
                    f << "Spigoter:\n"
                    f << "  build_dir: build\n"
                    f << "  plugins_dir: plugins\n"
                    f << "  javaparams: \"-Xms1G -Xmx2G\"\n"
                    f << "  spigot_version: latest\n"
                }
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
