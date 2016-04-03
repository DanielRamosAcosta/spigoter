require 'spec_helper'

describe Spigoter::CLI do
    describe "#main" do
        describe "executing the server" do
            it "With default parameters, " do
                Spigoter::CLI.run('start')
            end
        end
        describe "updating plugins" do
            before :all do
                Dir.chdir('tmp')
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
            after :all do
                FileUtils.rm_rf(Dir.glob("*"))
                Dir.chdir('..')
            end
            it "With default parameters" do
                Spigoter::CLI.run('update')
                expect(File.open("plugins/Authme.jar").size).to be_within(10000).of(1796785)
                expect(File.open("plugins/BossShop.jar").size).to be_within(10000).of(195800)
                expect(File.open("plugins/Dynmap.jar").size).to be_within(10000).of(4102422)
            end
        end
    end
end
