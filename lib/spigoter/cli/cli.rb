module Spigoter
	module CLI
		def self.run(command, opts={})
			Run.new.exec[command].call(opts)
		end
		def self.java?
			if which('java').nil?
				return false
			end
			return true
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