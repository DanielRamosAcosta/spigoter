module Spigoter
	class Server
		def initialize(servername)
			Dir.mkdir(servername[:name])
		end
	end
end