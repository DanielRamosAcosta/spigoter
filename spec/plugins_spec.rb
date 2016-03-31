require 'spec_helper'
require 'fileutils'
require 'json'


describe 'Spigoter.update' do
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
	end
	describe '#update' do
		before :each do
			Dir.mkdir 'tmp/plugins'
		end
		it 'Se le debe pasar un json' do
			Spigoter.update(@plugins, 'tmp/plugins')
			expect(File.open('tmp/plugins/Authme.jar').size).to be_within(10000).of(1796786)
			expect(File.open('tmp/plugins/BossShop.jar').size).to be_within(10000).of(195801)
		end
		after :each do
			FileUtils.rm_r 'tmp/plugins'
		end
	end
end