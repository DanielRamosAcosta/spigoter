require 'spec_helper'
require 'fileutils'

describe Spigoter::PluginCurse do
	before :all do
		@plugin = Spigoter::PluginCurse.new('http://mods.curse.com/bukkit-plugins/minecraft/multiverse-core')
	end
	describe '#initialize' do
		it 'with a website' do
			Spigoter::PluginCurse.new('http://mods.curse.com/bukkit-plugins/minecraft/multiverse-core')
		end
	end
	describe '#version' do
		it 'right now, multiverse-core version is 2.4-AB' do
			expect(@plugin.version).to eq('2.4-AB')
		end
	end
	describe '#name' do
		it 'we can get the plugin\'s name' do
			expect(@plugin.name).to eq('multiverse-core')
		end
	end
	describe '#download_url' do
		it 'we can get the download url' do
			expect(@plugin.download_url).to eq('http://addons.curse.cursecdn.com/files/588/781/Multiverse-Core-2.4.jar')
		end
	end
	describe '#download' do
		it 'we can download the plugin' do
			@plugin.download do |f|
   				File.open('plugin.jar', 'wb') do |file|
     				file.puts f.read
   				end
			end
			expect(File.open('plugin.jar').size).to be_within(10000).of(325808)
		end
		after :all do
			FileUtils.rm 'plugin.jar'
		end
	end
end