require 'spec_helper'

describe Spigoter::CLI do
	describe "#update" do
		before :each do
			Dir.chdir('tmp')
		end
		after :each do
			FileUtils.rm_rf(Dir.glob("*"))
			Dir.chdir('..')
		end
		describe "updating all plugins" do
			before :each do
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
				  		}
					]
				')
			json.close
			end
			after :each do
				FileUtils.rm_rf(Dir.glob("*"))
			end
			it "With default parameters, " do
				opts = {:javaparm=>"-Xms1024M -Xmx4096M -jar spigot.jar", :compile=>false, :update=>true, :help=>false, :update_given=>true}
				Spigoter::CLI.update(opts)
				expect(File.open("plugins/Authme.jar").size).to be_within(10000).of(1796785)
				expect(File.open("plugins/BossShop.jar").size).to be_within(10000).of(195800)
			end
			it "If no plugins.json is found, exit with 1" do
				opts = {:javaparm=>"-Xms1024M -Xmx4096M -jar spigot.jar", :compile=>false, :update=>true, :help=>false, :update_given=>true}
				FileUtils.rm('plugins.json')
				expect{Spigoter::CLI.update(opts)}.to raise_error SystemExit
			end
			it "If no plugins dir is found, exit with 1" do
				opts = {:javaparm=>"-Xms1024M -Xmx4096M -jar spigot.jar", :compile=>false, :update=>true, :help=>false, :update_given=>true}
				FileUtils.rm_rf('plugins')
				expect{Spigoter::CLI.update(opts)}.to raise_error SystemExit
			end
		end
	end
end