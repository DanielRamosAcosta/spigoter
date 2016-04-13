require "spec_helper"
require "fileutils"

describe Spigoter::PluginBukkit, "#initialize" do
    context "with a valid URL" do
        it "creates the object" do
            pln = Spigoter::PluginBukkit.new("http://dev.bukkit.org/bukkit-plugins/paintingswitch/")
            expect(pln.class.to_s).to eq("Spigoter::PluginBukkit")
        end
        context "but without an internet connection" do
            before :each do
                allow(Spigoter::Utils).to receive(:open).and_raise(SocketError)
            end
            it "raises an error" do
                expect{Spigoter::PluginBukkit.new("http://dev.bukkit.org/bukkit-plugins/paintingswitch/")}
                .to raise_error "Can't download anything from http://dev.bukkit.org/bukkit-plugins/paintingswitch/, check internet or URL?"
            end
        end
    end
    context "with a wrong URL" do
        it "raises an error" do
            expect{Spigoter::PluginBukkit.new("http://dev.bukkit.org/bukkit-plugins")}
            .to raise_error "Bad URL http://dev.bukkit.org/bukkit-plugins"
        end
        it "raises an error" do
            expect{Spigoter::PluginBukkit.new("http://dev.bukkit.org/bukkit-plugins/????????")}
            .to raise_error "Bad URL http://dev.bukkit.org/bukkit-plugins/????????"
        end
        it "raises an error" do
            expect{Spigoter::PluginBukkit.new("http://dev.bukkit.org/bukkit-plugins/unknownplugin/")}
            .to raise_error "Can't download anything from http://dev.bukkit.org/bukkit-plugins/unknownplugin/, check internet or URL?"
        end
    end
end

describe Spigoter::PluginBukkit do
    before :each do
        @plugin = Spigoter::PluginBukkit.new("http://dev.bukkit.org/bukkit-plugins/paintingswitch/")
    end
    describe "#version" do
        it "returns current version" do
            expect(@plugin.version).to eq("neoPaintingSwitch 1.371")
        end
    end
    describe "#name" do
        it "returns the plugin name" do
            expect(@plugin.name).to eq("neoPaintingSwitch")
        end
    end
    describe "#file" do
        it "returns the file (myPlugin.jar)" do
            expect(@plugin.file.size).to be_within(10000).of(13173) #+-1M from the original, if the author updates the plugin...
        end
    end
end

describe Spigoter::PluginBukkit do
    before :each do
        @plugin = Spigoter::PluginBukkit.new("http://dev.bukkit.org/bukkit-plugins/worldguard/")
    end
    describe "#version" do
        it "returns current version" do
            expect(@plugin.version).to eq("WorldGuard 6.1")
        end
    end
    describe "#name" do
        it "returns the plugin name" do
            expect(@plugin.name).to eq("WorldGuard")
        end
    end
end
