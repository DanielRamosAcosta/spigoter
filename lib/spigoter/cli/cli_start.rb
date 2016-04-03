module Spigoter
	module CLI
		def self.start
			return Start::start
		end
		module Start
			def self.start
				return lambda do |opts|
					main(opts)
				end
			end
			def self.main(opts = {})
				unless Spigoter::Utils.which('java').nil?
					Log.info "Starting the server!"
					system("java #{opts[:javaparm]} -jar spigot.jar")
				else
					Log.error "You don't have java in PATH"
				end
			end
		end
	end
end