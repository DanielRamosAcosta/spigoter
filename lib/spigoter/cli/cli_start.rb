module Spigoter
	module CLI
		@@start = lambda do |opts|
			unless java?
				Log.info "Starting the server!"
				system("java #{opts[:javaparm]} -jar spigot.jar")
			else
				Log.error "You don't have java in PATH"
			end
		end

		def self.start
			return @@start
		end
	end
end