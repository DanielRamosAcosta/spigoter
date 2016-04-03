module Spigoter
	module CLI
		def self.update
			return Update::update
		end
		module Update
			def self.update
				return lambda do |opts|
					main(opts)
				end
			end
			def self.main(opts)
				Log.info "Updating!"
				unless File.exist?('plugins.yml')
					Log.error "plugins.yml doesn't exists, please, create one (you can use spigoter init)"
					exit(1)
				end
				unless Dir.exist?('plugins')
					Log.error "plugins directory doesn't exists, please, create it"
					exit(1)
				end

				file = File.read('plugins.yml')
				plugins_data = YAML.load(file)
				list = plugins_data.keys
				unless opts[:list].nil?
					unless opts[:list].empty?
						list = opts[:list]
					end
				end

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