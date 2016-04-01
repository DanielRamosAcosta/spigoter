module Spigoter
	module Plugins
		def self.get_plugin(name, data)
			case data['type']
				when 'curse'
					f = Spigoter::PluginCurse.new(data['url']).download
					hash = {:name => "#{name}.jar", :file => f}
					return hash
				when 'devbukkit'
					f = Spigoter::PluginBukkit.new(data['url']).download
					hash = {:name => "#{name}.jar", :file => f}
					return hash
				else
					raise "Unkown source"
			end
		end
	end
end