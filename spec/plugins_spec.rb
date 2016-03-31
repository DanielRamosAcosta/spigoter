require 'spec_helper'
require 'fileutils'
require 'json'


describe Spigoter::Plugins do
	before :all do
		json ='[
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
		]'
		@plugins = JSON.parse(json)
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
		it "se debe lanzar una excepcion si se desconoce el tipo" do
			expect{Spigoter::Plugins.get_plugin(@bad_type)}.to raise_error(RuntimeError, "Unkown source")
		end
		it "se debe lanzar una excepcion si no se consigue descargar o la url esta mal" do
			expect{Spigoter::Plugins.get_plugin(@bad_url)}.to raise_error(RuntimeError, "Bad URL http://mods.curse.com/bukkit-plugins/minecraft/?????????")
		end
	end
end