require 'open-uri'

module Spigoter
    module Utils
        def self.download(url)
            begin
                file = open(url).read
            rescue
                raise "Can't download anything from #{url}, check internet or URL?"
            end
            return file
        end

        def self.loadyaml(path)
            raise "File #{path} doesn't exists" unless File.exist?(path)
            opts = YAML.load(File.open(path).read)
            if opts.class != Hash
                raise "Malformed YAML file #{path}"
            else
                return opts
            end
        end

        def self.which(cmd)
            # http://stackoverflow.com/questions/2108727/which-in-ruby-checking-if-program-exists-in-path-from-ruby
            exts = ENV['PATHEXT'] ? ENV['PATHEXT'].split(';') : ['']
            ENV['PATH'].split(File::PATH_SEPARATOR).each do |path|
                exts.each { |ext|
                    exe = File.join(path, "#{cmd}#{ext}")
                    return exe if File.executable?(exe) && !File.directory?(exe)
                }
            end
            return nil
        end

        def self.symbolize(hash)
            return hash.inject({}){|memo,(k,v)| memo[k.to_sym] = v; memo}
        end

        def self.fill_opts_config
            raise "spigoter.yml doesn't exists, do 'spigoter init'" unless File.exist?('spigoter.yml')

            opts = loadyaml('spigoter.yml')

            opts = {} if opts.nil?
            opts['Spigoter'] = {} if opts['Spigoter'].nil?
            opts = Spigoter::Utils::symbolize(opts['Spigoter'])

            opts[:build_dir] = 'build' if opts[:build].nil?
            opts[:plugins_dir] = 'plugins' if opts[:plugins_dir].nil?
            opts[:javaparams] = '-Xms1G -Xmx2G' if opts[:javaparams].nil?
            opts[:spigot_version] = Spigoter::SPIGOT_VERSION if opts[:spigot_version].nil?
            return opts
        end
    end
end
