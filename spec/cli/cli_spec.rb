require 'spec_helper'

describe Spigoter::CLI do
	describe "#main" do
		describe "executing the server" do
			it "With default parameters, " do
				Spigoter::CLI.main({:javaparm=>"-Xms1024M -Xmx4096M -jar spigot.jar", :compile=>false, :update=>false, :help=>false})
			end
		end
		describe "updating plugins" do
			before :all do
				Dir.chdir('tmp')
				Dir.mkdir('plugins')
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
				  		},
				  		{
					   		"name": "Dynmap",
				  			"url": "http://dev.bukkit.org/bukkit-plugins/dynmap/",
				  			"type": "devbukkit",
				  			"last_update": "31-3-2016 - 0:40"
				  		}
					]
				')
				json.close
			end
			after :all do
				FileUtils.rm_rf(Dir.glob("*"))
				Dir.chdir('..')
			end
			it "With default parameters, " do
				Spigoter::CLI.main({:javaparm=>"-Xms1024M -Xmx4096M -jar spigot.jar", :compile=>false, :update=>true, :help=>false})
				expect(File.open("plugins/Authme.jar").size).to be_within(10000).of(1796785)
				expect(File.open("plugins/BossShop.jar").size).to be_within(10000).of(195800)
				expect(File.open("plugins/Dynmap.jar").size).to be_within(10000).of(4102422)
			end
		end
	end
end