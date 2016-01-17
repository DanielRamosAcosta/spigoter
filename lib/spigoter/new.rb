module Spigoter
	class Server
		def initialize(servername)
			raise ArgumentError, "I need the server name" if servername[:name].nil?
			@servername = servername[:name]
			@path = Dir.pwd
			setup_server()
			Dir.chdir(@path)
		end
		def setup_server
			Dir.mkdir(@servername)
			Dir.chdir(@servername)
			Dir.mkdir("build")
		end
	end
end