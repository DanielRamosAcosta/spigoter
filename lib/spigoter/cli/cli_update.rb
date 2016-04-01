module Spigoter
	module CLI
		def self.update(opts)
			Log.info "Updating!"
			unless File.exists?('plugins.yml')
				Log.error "plugins.yml doesn't exists, please, create one"
				exit(1)
			end
			unless Dir.exists?('plugins')
				Log.error "plugins directory doesn't exists, please, create it"
				exit(1)
			end

			file = File.read('plugins.yml')
			plugins = YAML.load(file)
			plugins.each do |name, data|
				begin
					Log.info "Starting to download #{name}"
					hash = Plugins.get_plugin(name, data)
					plugin_file = File.open("plugins/#{name}.jar", 'wb')
					plugin_file.write(hash[:file])
					Log.info "#{name} was downloaded correctly"
				rescue Exception => e
					Log.error "Unkown source #{data['type']}"
				end
			end
		end
	end
end