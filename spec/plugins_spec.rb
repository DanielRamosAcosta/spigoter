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
		@bad_plugin = {
				name: "Authme",
				url: "http://mods.curse.com/bukkit-plugins/minecraft/authme-reloaded",
				type: "????????",
				last_update: "31-3-2016 - 0:40"
			}
	end
	describe '#get_plugin' do
		it "se debe lanzar una excepcion si se desconoce el tipo" do
			expect{Spigoter::Plugins.get_plugin(@bad_plugin)}.to raise_error(RuntimeError, "Unkown source")
		end
	end
	describe '#update' do
		before :all do
			Dir.mkdir 'tmp/plugins'
		end
		it 'Se le debe pasar un json' do
			Spigoter::Plugins.update(@plugins, 'tmp/plugins')
			expect(File.open('tmp/plugins/Authme.jar').size).to be_within(10000).of(1796786)
			expect(File.open('tmp/plugins/BossShop.jar').size).to be_within(10000).of(195801)
		end
		after :each do
			FileUtils.rm_r 'tmp/plugins'
		end
	end
end