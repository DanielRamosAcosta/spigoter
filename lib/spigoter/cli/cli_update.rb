module Spigoter
	module CLI
		def self.update(opts)
			puts opts
			Log.info "Updating!"
			unless File.exists?('plugins.json')
				Log.error "plugins.json doesn't exists, please, create one"
				exit(1)
			end
			unless Dir.exists?('plugins')
				Log.error "plugins directory doesn't exists, please, create it"
				exit(1)
			end

			file = File.read("plugins.json")
			plugins = JSON.parse(file)
			plugins.each do |plugin_data|
				Log.info "Getting plugin #{plugin_data['name']}"
				begin
					hash = Plugins.get_plugin(plugin_data)
					plugin_file = File.open("plugins/#{hash[:name]}", 'wb')
					plugin_file.write(hash[:file])
					Log.info "#{plugin_data['name']} was downloaded correctly"
				rescue Exception => e
					Log.error "Unkown source #{plugin_data['type']}"
				end
			end
		end
	end
end