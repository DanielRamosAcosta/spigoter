module Spigoter
	module Plugins
		def self.get_plugin(name, data)
			f = nil
			case data['type']
				when 'curse'
					f = Spigoter::PluginCurse.new(data['url']).download
				when 'devbukkit'
					f = Spigoter::PluginBukkit.new(data['url']).download
				else
					raise "Unkown source"
			end
			hash = {:name => "#{name}.jar", :file => f}
			return hash
		end
	end
end