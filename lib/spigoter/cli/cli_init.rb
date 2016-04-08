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
            def self.main(*)
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
                if Dir.exist?('plugins') and !Dir['plugins/*.jar'].empty?
                    open('plugins.yml', 'w+') { |f|
                        f << "---\n"
                        f << "Plugins:\n"
                        Dir['plugins/*.jar'].each do |plg|
                            f << "  #{File.basename(plg).gsub(/.jar/, "")}:\n"
                            f << "    # type: {curse|devbukkit|....}\n"
                            f << "    # url: http://something.com\n"
                        end
                    }
                else
                    open('plugins.yml', 'w+') { |f|
                        f << "---\n"
                        f << "Plugins:\n"
                        f << "  # Plugin1:\n"
                        f << "    # type: {curse|devbukkit|....}\n"
                        f << "    # url: http://something.com\n"
                    }
                end
            end
        end
    end
end
