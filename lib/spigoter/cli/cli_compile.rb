module Spigoter
	module CLI
		@@compile = lambda do |opts|
			puts opts
		end

		def self.compile
			return @@compile
		end
	end
end