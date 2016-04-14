require 'open-uri'

module Spigoter
  # Module with some methods commons to everyone.
  # @author Daniel Ramos Acosta <danielramosacosta@hotmail.com>
  module Utils
    def self.download(url)
      open(url).read
    rescue
      raise "Can't download anything from #{url}, check internet or URL?"
    end

    def self.loadyaml(path)
      raise "File #{path} doesn't exists" unless File.exist?(path)

      opts = YAML.load(File.open(path).read)

      raise "Malformed YAML file #{path}" unless opts.class == Hash
      opts
    end

    def self.which(cmd)
      # http://stackoverflow.com/questions/2108727/which-in-ruby-checking-if-program-exists-in-path-from-ruby
      exts = ENV['PATHEXT'] ? ENV['PATHEXT'].split(';') : ['']
      ENV['PATH'].split(File::PATH_SEPARATOR).each do |path|
        exts.each do |ext|
          exe = File.join(path, "#{cmd}#{ext}")
          return exe if File.executable?(exe) && !File.directory?(exe)
        end
      end
      nil
    end

    def self.symbolize(hash)
      new_hash = {}
      hash.each { |k, v| new_hash[k.to_sym] = v }
      new_hash
    end

    def self.fill_opts_config
      raise "spigoter.yml doesn't exists, do 'spigoter init'" unless File.exist?('spigoter.yml')

      opts = loadyaml('spigoter.yml')

      opts = {} if opts.nil?
      opts['Spigoter'] = {} if opts['Spigoter'].nil?
      opts = Spigoter::Utils.symbolize(opts['Spigoter'])
      default_opts(opts)
    end

    def self.default_opts(opts)
      opts[:build_dir] = 'build' if opts[:build_dir].nil?
      opts[:plugins_dir] = 'plugins' if opts[:plugins_dir].nil?
      opts[:javaparams] = '-Xms1G -Xmx2G' if opts[:javaparams].nil?
      opts[:spigot_version] = Spigoter::SPIGOT_VERSION if opts[:spigot_version].nil?
      opts
    end

    def self.get_plugins(opts = {})
      raise "spigoter.yml doesn't exists, do 'spigoter init'" unless File.exist?('plugins.yml')

      plugins_data = loadyaml('plugins.yml')['Plugins']
      plugins_data = normalize_plugins(plugins_data)
      truncate_to_list(plugins_data, opts)
    end

    def self.normalize_plugins(plugins)
      plugins = symbolize(plugins)

      plugins.each do |key, plugin|
        plugins[key] = symbolize(plugin)
        plugins[key][:type] = plugins[key][:type].to_sym
      end
    end

    def self.truncate_to_list(plugin, opts)
      leftovers = {}
      if !opts[:list].nil? && !opts[:list].empty?
        list = opts[:list] # If a list cames in opts, use it
        list.each do |key|
          leftovers[key] = plugin[key]
        end
      else
        leftovers = plugin
      end
      leftovers
    end
  end
end
