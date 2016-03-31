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
	it 'Se le debe pasar un json' do
		Spigoter.update(@plugins)
		expect(true).to be true
	end
end