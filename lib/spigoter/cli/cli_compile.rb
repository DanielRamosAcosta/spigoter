module Spigoter
	module CLI
		def self.compile
			return Compile::compile
		end
		module Compile
			def self.compile
				return lambda do |opts|
					main(opts)
				end
			end
			def self.main(opts = {})
				if !Spigoter::Utils.which('java').nil? and !Spigoter::Utils.which('git').nil?
					Log.info "Compiling Spigot!"
					FileUtils.mkdir_p 'build'
					Dir.chdir('build')
					unless File.exist?('BuildTools.jar')
						file = Spigoter::Utils.download('https://hub.spigotmc.org/jenkins/job/BuildTools/lastSuccessfulBuild/artifact/target/BuildTools.jar')
						File.open('BuildTools.jar', 'wb').write(file)
					end
					if opts[:version].nil?
						Log.info "Compiling lastest spigot version"
						system("java -jar BuildTools.jar")
					else
						Log.info "Compiling spigot version #{opts[:version]}"
						system("java -jar BuildTools.jar --rev #{opts[:version]}")
					end
					Dir.chdir('..')
					FileUtils.cp(Dir['build/spigot*.jar'].first, 'spigot.jar')
				else
					Log.error "You don't have java or git in PATH"
				end
			end
		end
	end
end