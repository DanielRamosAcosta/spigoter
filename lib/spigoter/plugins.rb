module Spigoter
	def self.update(plugins)
		downloads = []


		plugins.each do |plugin|
			puts plugin
			case plugin['type']
				when 'curse'
					puts 'Plugin alojado en curse'
					Spigoter::PluginCurse.new(plugin['url']).download do |f|
     					downloads.push({:file=>f, :name=>plugin['name']})
					end
				else
					puts "***********Unkown source #{plugin[:type]}******************"
			end
		end

		downloads.each do |plugin|
			File.open(plugin[:name]+'.jar', 'wb') do |file|
     			file.puts plugin[:file].read #TODO: depurar este metodo
   			end
		end
	end
end