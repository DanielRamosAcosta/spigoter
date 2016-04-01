module Spigoter
	module CLI
		def self.run(command, opts={})
			Run.new.exec[command].call(opts)
		end
		class Run
			attr_reader :tasks
			def initialize
				@tasks = {
					'update' => Spigoter::CLI.update,
					'compile' => Spigoter::CLI.compile,
					'start' => Spigoter::CLI.start
				}
			end
			def exec
				@tasks
			end
		end
	end
end