module Spigoter
	module Plugins
		@log = Logging.logger['Spigoter::Plugins']
  		@log.add_appenders 'stdout'
	  	@log.level = :info

		def self.update(plugins, output_dir)
			plugins.each do |plugin_data|
				@log.info "Getting plugin #{plugin_data['name']}"
				get_plugin(plugin_data) do |plugin|
					File.open("#{output_dir}/#{plugin[:name]}", 'wb') do |file|
	     				file.puts plugin[:file].read
	     			end
				end
			end
		end
		def self.get_plugin(data)
			case data['type']
				when 'curse'
					Spigoter::PluginCurse.new(data['url']).download do |f|
						hash = {:name => "#{data['name']}.jar", :file => f}
						yield hash
					end
				else
					raise "Unkown source"
			end
		end
	end
end