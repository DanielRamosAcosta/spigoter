require "spec_helper"
require "fileutils"

describe Spigoter::PluginBukkit do
    before :all do
        #@plugin = Spigoter::PluginBukkit.new("http://dev.bukkit.org/bukkit-plugins/dynmap/")
        #@unk_plugin = Spigoter::PluginBukkit.new("http://dev.bukkit.org/bukkit-plugins/asdasdwawdasdqawdas/")
    end
    describe "#initialize" do
        xit "with a website" do
            Spigoter::PluginBukkit.new("http://dev.bukkit.org/bukkit-plugins/dynmap/")
        end
        xit "if is a wrong URL, raise error" do
            expect{Spigoter::PluginBukkit.new("http://dev.bukkit.org/bukkit-plugins")}.to raise_error "Bad URL http://dev.bukkit.org/bukkit-plugins"
        end
        xit "if is a wrong URL, raise error" do
            expect{Spigoter::PluginCurse.new("http://dev.bukkit.org/bukkit-plugins/????")}.to raise_error "Bad URL http://dev.bukkit.org/bukkit-plugins/????"
        end
    end
    describe "#version" do
        xit "right now, dynmap version is v2.2" do
            expect(@plugin.version).to eq("v2.2")
        end
    end
    describe "#name" do
        xit "we can get the plugin\"s name" do
            expect(@plugin.name).to eq("dynmap")
        end
    end
    describe "#download_url" do
        xit "we can get the download url" do
            expect(@plugin.download_url).to eq("http://dev.bukkit.org/media/files/888/859/dynmap-2.2.jar")
        end
    end
    describe "#download" do
        xit "we can download the plugin" do
            file = File.open("tmp/plugin.jar", "wb")
            downloaded = @plugin.file
            file.write(downloaded)
            expect(file.size).to be_within(10000).of(4094534)
        end
        xit "if the plugin doesnt exists" do
            expect{@unk_plugin.file}.to raise_error(RuntimeError, "404 Error, that plugin URL doesn't exists")
            expect{@unk_plugin.download_page}.to raise_error(RuntimeError, "404 Error, that plugin URL doesn't exists")
            expect{@unk_plugin.version}.to raise_error(RuntimeError, "404 Error, that plugin URL doesn't exists")
        end
        after :all do
            #FileUtils.rm "tmp/plugin.jar"
        end
    end
end
