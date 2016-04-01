module Spigoter
	module CLI
		@@start = lambda do |opts|
			unless which('java').nil?
				Log.info "Starting the server!"
				system("java #{opts[:javaparm]} -jar spigot.jar")
			else
				Log.error "You don't have java in PATH"
			end
		end

		def self.start
			return @@start
		end

		def self.which(cmd)
			# http://stackoverflow.com/questions/2108727/which-in-ruby-checking-if-program-exists-in-path-from-ruby
			exts = ENV['PATHEXT'] ? ENV['PATHEXT'].split(';') : ['']
			ENV['PATH'].split(File::PATH_SEPARATOR).each do |path|
				exts.each { |ext|
					exe = File.join(path, "#{cmd}#{ext}")
					return exe if File.executable?(exe) && !File.directory?(exe)
				}
			end
			return nil
		end
	end
end