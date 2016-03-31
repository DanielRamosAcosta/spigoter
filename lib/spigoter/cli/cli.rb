module Spigoter
	module CLI
		def self.main(opts)
			Log.info "Estoy en la main, mi opts son: #{opts}"
			if(opts[:update])
				Spigoter::CLI.update(opts)
				return
			end
			if(opts[:compile])
				Spigoter::CLI.compile(opts)
				return
			end
			Spigoter::CLI.start(opts)
		end
	end
end