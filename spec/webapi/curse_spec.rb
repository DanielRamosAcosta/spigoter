require "spec_helper"
require "fileutils"

describe Spigoter::PluginCurse do
	before :all do
		@plugin = Spigoter::PluginCurse.new("http://mods.curse.com/bukkit-plugins/minecraft/multiverse-core")
		@unk_plugin = Spigoter::PluginCurse.new("http://mods.curse.com/bukkit-plugins/minecraft/unkownplugin")
	end
	describe "#initialize" do
		it "with a website" do
			Spigoter::PluginCurse.new("http://mods.curse.com/bukkit-plugins/minecraft/multiverse-core")
		end
		it "if is a wrong URL, raise error" do
			expect{Spigoter::PluginCurse.new("http://mods.curse.com/bukkit-plugins")}.to raise_error "Bad URL http://mods.curse.com/bukkit-plugins"
		end
		it "if is a wrong URL, raise error" do
			expect{Spigoter::PluginCurse.new("http://mods.curse.com/bukkit-plugins/minecraft/????")}.to raise_error "Bad URL http://mods.curse.com/bukkit-plugins/minecraft/????"
		end
	end
	describe "#version" do
		it "right now, multiverse-core version is 2.4-AB" do
			expect(@plugin.version).to eq("2.4-AB")
		end
	end
	describe "#name" do
		it "we can get the plugin\"s name" do
			expect(@plugin.name).to eq("multiverse-core")
		end
	end
	describe "#download_url" do
		it "we can get the download url" do
			expect(@plugin.download_url).to eq("http://addons.curse.cursecdn.com/files/588/781/Multiverse-Core-2.4.jar")
		end
	end
	describe "#download" do
		it "we can download the plugin" do
			file = File.open("tmp/plugin.jar", "wb")
			downloaded = @plugin.download
			file.write(downloaded)
			expect(file.size).to be_within(10000).of(325808)
		end
		it "if the plugin doesnt exists" do
			expect{downloaded = @unk_plugin.download}.to raise_error(RuntimeError, "404 Error, that plugin URL doesn't exists")
		end
		after :all do
			FileUtils.rm "tmp/plugin.jar"
		end
	end
end