module Spigoter
	module Plugins
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