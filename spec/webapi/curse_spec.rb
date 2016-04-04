require "spec_helper"
require "fileutils"

describe Spigoter::PluginCurse, "#initialize" do
    context "with a valid URL" do
        it "creates the object" do
            pln = Spigoter::PluginCurse.new("http://mods.curse.com/bukkit-plugins/minecraft/firstjoinplus")
            expect(pln.class.to_s).to eq("Spigoter::PluginCurse")
        end
        context "but without an internet connection" do
            before :each do
                allow(Spigoter::Utils).to receive(:open).and_raise(SocketError)
            end
            it "raises an error" do
                expect{Spigoter::PluginCurse.new("http://mods.curse.com/bukkit-plugins/minecraft/firstjoinplus")}
                .to raise_error "Can't download anything from http://mods.curse.com/bukkit-plugins/minecraft/firstjoinplus, check internet or URL?"
            end
        end
    end
    context "with a wrong URL" do
        it "raises an error" do
            expect{Spigoter::PluginCurse.new("http://mods.curse.com/bukkit-plugins")}
            .to raise_error "Bad URL http://mods.curse.com/bukkit-plugins"
        end
        it "raises an error" do
            expect{Spigoter::PluginCurse.new("http://mods.curse.com/bukkit-plugins/minecraft/????")}
            .to raise_error "Bad URL http://mods.curse.com/bukkit-plugins/minecraft/????"
        end
        it "raises an error" do
            expect{Spigoter::PluginCurse.new("http://mods.curse.com/bukkit-plugins/minecraft/unknownplugin")}
            .to raise_error "Can't download anything from http://mods.curse.com/bukkit-plugins/minecraft/unknownplugin, check internet or URL?"
        end
    end
end

describe Spigoter::PluginCurse do
    before :each do
        @plugin = Spigoter::PluginCurse.new("http://mods.curse.com/bukkit-plugins/minecraft/firstjoinplus")
    end
    describe "#version" do
        it "returns current version" do
            expect(@plugin.version).to eq("FirstJoinPlus v2.4")
        end
    end
    describe "#name" do
        it "returns the plugin name" do
            expect(@plugin.name).to eq("FirstJoinPlus")
        end
    end
    describe "#file" do
        it "returns the file (myPlugin.jar)" do
            expect(@plugin.file.size).to be_within(10000).of(52309) #+-1M from the original, if the author updates the plugin...
        end
    end
end
