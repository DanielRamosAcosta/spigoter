require "spec_helper"
require "fileutils"

describe Spigoter::PluginCurse, "#initialize" do
    context "with a valid URL" do
        it "creates the object" do
            pln = Spigoter::PluginCurse.new("http://mods.curse.com/bukkit-plugins/minecraft/firstjoinplus")
            expect(pln.class.to_s).to eq("Spigoter::PluginCurse")
        end
    end
    context "with wrong URL" do
        it "raise error" do
            expect{Spigoter::PluginCurse.new("http://mods.curse.com/bukkit-plugins")}.to raise_error "Bad URL http://mods.curse.com/bukkit-plugins"
        end
        it "raise error" do
            expect{Spigoter::PluginCurse.new("http://mods.curse.com/bukkit-plugins/minecraft/????")}.to raise_error "Bad URL http://mods.curse.com/bukkit-plugins/minecraft/????"
        end
        it "raise error" do
            expect{Spigoter::PluginCurse.new("http://mods.curse.com/bukkit-plugins/minecraft/unknownplugin")}.to raise_error "404 Error, that plugin URL doesn't exists"
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
