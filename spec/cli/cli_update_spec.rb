require 'spec_helper'
require 'rspec/logging_helper'

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
				yml = File.open("plugins.yml", 'wb')
				yml.write('
Authme:
  url: "http://mods.curse.com/bukkit-plugins/minecraft/authme-reloaded"
  type: "curse"
BossShop:
  url: "http://mods.curse.com/bukkit-plugins/minecraft/bossshop"
  type: "curse"
Dynmap:
  url: "http://dev.bukkit.org/bukkit-plugins/dynmap/"
  type: "devbukkit"')
				yml.close
			end
			after :each do
				FileUtils.rm_rf(Dir.glob("*"))
			end
			it "With default parameters, " do
				opts = {:javaparm=>"-Xms1024M -Xmx4096M -jar spigot.jar", :compile=>false, :update=>true, :help=>false, :update_given=>true}
				Spigoter::CLI.update.call(opts)
				expect(File.open("plugins/Authme.jar").size).to be_within(10000).of(1796785)
				expect(File.open("plugins/BossShop.jar").size).to be_within(10000).of(195800)
				expect(File.open("plugins/Dynmap.jar").size).to be_within(10000).of(4102422)
			end
			it "If no plugins.yml is found, exit with 1" do
				opts = {:javaparm=>"-Xms1024M -Xmx4096M -jar spigot.jar", :compile=>false, :update=>true, :help=>false, :update_given=>true}
				FileUtils.rm('plugins.yml')
				expect{Spigoter::CLI.update.call(opts)}.to raise_error SystemExit
			end
			it "If no plugins dir is found, exit with 1" do
				opts = {:javaparm=>"-Xms1024M -Xmx4096M -jar spigot.jar", :compile=>false, :update=>true, :help=>false, :update_given=>true}
				FileUtils.rm_rf('plugins')
				expect{Spigoter::CLI.update.call(opts)}.to raise_error SystemExit
			end
			it "It has to log an error if type is unknown" do
				yml = File.open("plugins.yml", 'wb')
				yml.write('
Authme:
  url: "http://mods.curse.com/bukkit-plugins/minecraft/authme-reloaded"
  type: "aksjdhaksjd"')
				yml.close
				opts = {:javaparm=>"-Xms1024M -Xmx4096M -jar spigot.jar", :compile=>false, :update=>true, :help=>false, :update_given=>true}
				Spigoter::CLI.update.call(opts)
				expect(@log_output.readline).to eq " INFO  Spigoter : Updating!\n"
				expect(@log_output.readline).to eq " INFO  Spigoter : Starting to download Authme\n"
				expect(@log_output.readline).to eq "ERROR  Spigoter : Unkown source aksjdhaksjd\n"
			end
		end
	end
end