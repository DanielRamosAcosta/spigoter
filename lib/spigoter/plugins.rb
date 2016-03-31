module Spigoter
	module Plugins
		@log = Logging.logger['Spigoter::Plugins']
  		@log.add_appenders 'stdout'
	  	@log.level = :info

		def self.update(plugins, output_dir)
			plugins.each do |plugin_data|
				@log.info "Getting plugin #{plugin_data['name']}"
				hash = get_plugin(plugin_data)
				plugin_file = File.open("#{output_dir}/#{hash[:name]}", 'wb')
				plugin_file.write(hash[:file])
				@log.info "#{plugin_data['name']} was downloaded correctly"
			end
		end
		def self.get_plugin(data)
			case data['type']
				when 'curse'
					f = Spigoter::PluginCurse.new(data['url']).download
					hash = {:name => "#{data['name']}.jar", :file => f}
					return hash
				else
					raise "Unkown source"
			end
		end
	end
end