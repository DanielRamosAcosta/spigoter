require 'spec_helper'
require 'fileutils'


describe Spigoter::Plugins do
    before :all do
        @plugin_curse = YAML.load('
            Authme:
              url: "http://mods.curse.com/bukkit-plugins/minecraft/authme-reloaded"
              type: "curse"')
        @plugin_devbukit = YAML.load('
            Dynmap:
              url: "http://dev.bukkit.org/bukkit-plugins/dynmap"
              type: "devbukkit"')
        @bad_type = YAML.load('
            Authme:
              url: "http://mods.curse.com/bukkit-plugins/minecraft/authme-reloaded"
              type: "????????"')
        @bad_url = YAML.load('
            Authme:
              url: "http://mods.curse.com/bukkit-plugins/minecraft/?????????"
              type: "curse"')
    end
    describe '#get_plugin' do
        describe "Se deben descargar bien los plugins" do
            xit "los de curse" do
                plugin_curse = File.open("tmp/plugin_curse.jar", 'wb')
                plugin_curse.write(Spigoter::Plugins.get_plugin(@plugin_curse.keys[0], @plugin_curse.values[0])[:file])
                expect(File.open("tmp/plugin_curse.jar").size).to be_within(10000).of(1796785)
            end
            xit "los de devbukkit" do
                plugin_bukkit = File.open("tmp/plugin_bukkit.jar", 'wb')
                plugin_bukkit.write(Spigoter::Plugins.get_plugin(@plugin_devbukit.keys[0], @plugin_devbukit.values[0])[:file])
                expect(File.open("tmp/plugin_bukkit.jar").size).to be_within(10000).of(4102422)
            end
            after :all do
                FileUtils.rm_rf(Dir.glob("tmp/*"))
            end
        end
        xit "se debe lanzar una excepcion si se desconoce el tipo" do
            expect{Spigoter::Plugins.get_plugin(@bad_type.keys[0], @bad_type.values[0])}.to raise_error(RuntimeError, "Unkown source")
        end
        xit "se debe lanzar una excepcion si no se consigue descargar o la url esta mal" do
            expect{Spigoter::Plugins.get_plugin(@bad_url.keys[0], @bad_url.values[0])}.to raise_error(RuntimeError, "Bad URL http://mods.curse.com/bukkit-plugins/minecraft/?????????")
        end
    end
end
