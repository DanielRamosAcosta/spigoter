require 'open-uri'

module Spigoter
	module Utils
		def self.download(url)
			begin
				file = open(url).read
			rescue
				raise "Can't download anything from #{url}, check internet?"
			end
			return file
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