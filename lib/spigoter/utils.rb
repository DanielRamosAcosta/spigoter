module Spigoter
	module Utils
		def download(url)
			begin
				file = open(url).read
			rescue
				raise "Can't download anything from #{url}, check internet?"
			end
			return file
		end
	end
end