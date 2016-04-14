module Spigoter
  # This module encloses all CLI commands.
  # @author Daniel Ramos Acosta <danielramosacosta@hotmail.com>
  module CLI
    def self.init
      Init.init
    end
    # Module for generating the necessary files.
    # @author Daniel Ramos Acosta <danielramosacosta@hotmail.com>
    module Init
      def self.init
        ->(*) { main }
      end

      def self.main(*)
        Log.info 'Generating files!'
        File.exist?('spigoter.yml') ? Log.warn('spigoter.yml alredy exists') : generate_spigoter
        File.exist?('plugins.yml')  ? Log.warn('plugins.yml alredy exists')  : generate_plugins
      end

      def self.generate_spigoter
        open('spigoter.yml', 'w+') do |f|
          f << "---\n"
          f << "Spigoter:\n"
          f << "  build_dir: build\n"
          f << "  plugins_dir: plugins\n"
          f << "  javaparams: \"-Xms1G -Xmx2G\"\n"
          f << "  spigot_version: latest\n"
        end
      end

      def self.generate_plugins
        if Dir.exist?('plugins') && !Dir['plugins/*.jar'].empty?
          generate_with_plugins
        else
          generate_empty
        end
      end

      def self.generate_with_plugins
        open('plugins.yml', 'w+') do |f|
          f << "---\n"
          f << "Plugins:\n"
          Dir['plugins/*.jar'].each do |plg|
            f << "  #{File.basename(plg).gsub(/.jar/, '')}:\n"
            f << "    # type: {curse|devbukkit|....}\n"
            f << "    # url: http://something.com\n"
          end
        end
      end

      def self.generate_empty
        open('plugins.yml', 'w+') do |f|
          f << "---\n"
          f << "Plugins:\n"
          f << "  # Plugin1:\n"
          f << "    # type: {curse|devbukkit|....}\n"
          f << "    # url: http://something.com\n"
        end
      end
    end
  end
end
