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
                Spigoter::CLI.update.call({})
                expect(File.open("plugins/Authme.jar").size).to be_within(10000).of(1796785)
                expect(File.open("plugins/BossShop.jar").size).to be_within(10000).of(195800)
                expect(File.open("plugins/Dynmap.jar").size).to be_within(10000).of(4102422)
            end
            it "With a list with specific plugins, " do
                Spigoter::CLI.update.call({:list=>["Authme", "BossShop"]})
                expect(File.open("plugins/Authme.jar").size).to be_within(10000).of(1796785)
                expect(File.open("plugins/BossShop.jar").size).to be_within(10000).of(195800)
                expect(File.exist?("plugins/Dynmap.jar")).to be false
            end
            it "If no plugins.yml is found, exit with 1" do
                FileUtils.rm('plugins.yml')
                expect{Spigoter::CLI.update.call({})}.to raise_error SystemExit
            end
            it "If no plugins dir is found, exit with 1" do
                FileUtils.rm_rf('plugins')
                expect{Spigoter::CLI.update.call({})}.to raise_error SystemExit
            end
            it "Log an error if type is Unkown" do
                yml = File.open("plugins.yml", 'wb')
                yml.write('
Authme:
  url: "http://mods.curse.com/bukkit-plugins/minecraft/authme-reloaded"
  type: "aksjdhaksjd"')
                yml.close
                Spigoter::CLI.update.call({})
                expect(@log_output.readline).to eq " INFO  Spigoter : Updating!\n"
                expect(@log_output.readline).to eq " INFO  Spigoter : Starting to download Authme\n"
                expect(@log_output.readline).to eq "ERROR  Spigoter : Unkown source aksjdhaksjd\n"
            end
        end
    end
end
