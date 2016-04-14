module Spigoter
  # This module encloses all CLI commands.
  # @author Daniel Ramos Acosta <danielramosacosta@hotmail.com>
  module CLI
    def self.update
      Update.update
    end
    # Module for updating plugins
    # @author Daniel Ramos Acosta <danielramosacosta@hotmail.com>
    module Update
      def self.update
        ->(opts = {}) { main(opts) }
      end

      def self.main(opts = {})
        Log.info 'Updating!'
        dependencies
        plugins_data = Spigoter::Utils.get_plugins(opts)

        plugins_data.each do |name, data|
          objeto = get_plugin(name, data)
          next unless !objeto.nil? && (objeto.class < Spigoter::Plugin)

          File.open("plugins/#{name}.jar", 'w+b') do |f|
            f.write(objeto.file)
          end
        end
      end

      def self.dependencies
        unless File.exist?('plugins.yml')
          Log.error "plugins.yml doesn't exists, please, create one (you can use spigoter init)"
          exit(1)
        end

        unless Dir.exist?('plugins')
          Log.error "plugins directory doesn't exists, please, create it"
          exit(1)
        end
      end

      def self.get_plugin(name, data)
        Log.info "Updating plugin: #{name}"
        plugin_type = data[:type]

        if Spigoter::Plugin.list[plugin_type].nil?
          Log.error "Plugin type #{plugin_type} doesn't exists!"
          exit(1)
        end

        Spigoter::Plugin.list[plugin_type].new(data[:url])
      rescue => e
        Log.error e.message
      end
    end
  end
end
