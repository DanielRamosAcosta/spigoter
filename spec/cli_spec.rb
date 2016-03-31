require 'spec_helper'
require 'open3'

def exec_with_args(args)
	captured_stdout = ''
	captured_stderr = ''
	exit_status = Open3.popen3("#{@exec} #{args}") do |stdin, stdout, stderr, wait_thr|
		pid = wait_thr.pid
		stdin.close
  		captured_stdout = stdout.read
  		captured_stderr = stderr.read
		wait_thr.value # Process::Status object returned.
	end
	return captured_stdout, captured_stderr, exit_status
end

describe "CLI" do
	before :all do
		Dir.chdir('tmp')
		@exec = "ruby -Ilib ../exe/spigoter"
	end

	describe "--update" do
		before :each do
			json = File.open("plugins.json", 'wb')
			json.write('
				[
					{
						"name": "Authme",
				    	"url": "http://mods.curse.com/bukkit-plugins/minecraft/authme-reloaded",
				    	"type": "curse",
				    	"last_update": "31-3-2016 - 0:40"
				  	},
				  	{
				   		"name": "BossShop",
				    	"url": "http://mods.curse.com/bukkit-plugins/minecraft/bossshop",
				    	"type": "curse",
				    	"last_update": "31-3-2016 - 0:40"
				  	}
				]
			')
			json.close
			Dir.mkdir('plugins')
		end
		after :each do
			FileUtils.rm_rf(Dir.glob("*"))
		end
		it "Plugins should be downloaded" do
			stdout, stderr, exit_status = exec_with_args("--update")
			expect(File.open("plugins/Authme.jar").size).to be_within(10000).of(1796785)
			expect(File.open("plugins/BossShop.jar").size).to be_within(10000).of(195800)
		end
		it "If no plugins.json is found, exit with 1" do
			FileUtils.rm('plugins.json')
			stdout, stderr, exit_status = exec_with_args("--update")
			expect(stderr.empty?).to be false
			expect(stderr).to match(/plugins.json doesn't exists, please, create one/)
		end
	end

	after :all do
		Dir.chdir('..')
		FileUtils.rm_rf('tmp/*')
	end
end