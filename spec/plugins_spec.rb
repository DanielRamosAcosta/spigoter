require 'spec_helper'
require 'fileutils'
require 'json'


describe Spigoter::Plugins do
	before :all do
		@plugin_curse = JSON.parse('{
					"name": "Authme",
				    "url": "http://mods.curse.com/bukkit-plugins/minecraft/authme-reloaded",
				    "type": "curse",
				    "last_update": "31-3-2016 - 0:40"
		}')
		@plugin_devbukit = JSON.parse('{
				  	"name": "Dynmap",
				  	"url": "http://dev.bukkit.org/bukkit-plugins/dynmap/",
				  	"type": "devbukkit",
				  	"last_update": "31-3-2016 - 0:40"
		}')
		@bad_type = JSON.parse('{
			"name": "Authme",
			"url": "http://mods.curse.com/bukkit-plugins/minecraft/authme-reloaded",
			"type": "????????",
			"last_update": "31-3-2016 - 0:40"
		}')
		@bad_url = JSON.parse('{
			"name": "Authme",
			"url": "http://mods.curse.com/bukkit-plugins/minecraft/?????????",
			"type": "curse",
			"last_update": "31-3-2016 - 0:40"
		}')
	end
	describe '#get_plugin' do
		describe "Se deben descargar bien los plugins" do
			it "los de curse" do
				plugin_curse = File.open("tmp/plugin_curse.jar", 'wb')
				plugin_curse.write(Spigoter::Plugins.get_plugin(@plugin_curse)[:file])
				expect(File.open("tmp/plugin_curse.jar").size).to be_within(10000).of(1796785)
			end
			it "los de devbukkit" do
				plugin_bukkit = File.open("tmp/plugin_bukkit.jar", 'wb')
				plugin_bukkit.write(Spigoter::Plugins.get_plugin(@plugin_devbukit)[:file])
				expect(File.open("tmp/plugin_bukkit.jar").size).to be_within(10000).of(4102422)
			end
			after :all do
				FileUtils.rm_rf(Dir.glob("tmp/*"))
			end
		end
		it "se debe lanzar una excepcion si se desconoce el tipo" do
			expect{Spigoter::Plugins.get_plugin(@bad_type)}.to raise_error(RuntimeError, "Unkown source")
		end
		it "se debe lanzar una excepcion si no se consigue descargar o la url esta mal" do
			expect{Spigoter::Plugins.get_plugin(@bad_url)}.to raise_error(RuntimeError, "Bad URL http://mods.curse.com/bukkit-plugins/minecraft/?????????")
		end
	end
end