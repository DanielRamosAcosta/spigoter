require 'spec_helper'
require 'rspec/logging_helper'

describe Spigoter::CLI do
    describe "#update" do
        before :each do
            Dir.chdir('tmp')
        end
        after :each do
            Dir.chdir('..')
        end
        context "if plugins.yml exists" do
            before :each do
                open('plugins.yml', 'w+') { |f|
                    f << "---\n"
                    f << "Plugins:\n"
                    f << "  FirstJoinPlus:\n"
                    f << "    url: \"http://mods.curse.com/bukkit-plugins/minecraft/firstjoinplus\"\n"
                    f << "    type: \"curse\"\n"
                    f << "  NeoPaintingSwitch:\n"
                    f << "    url: \"http://dev.bukkit.org/bukkit-plugins/paintingswitch\"\n"
                    f << "    type: \"devbukkit\"\n"
                }
            end
            after :each do
                FileUtils.rm_f('plugins.yml')
            end
            context "and plugins dir exists" do
                before :each do
                    Dir.mkdir('plugins')
                end
                after :each do
                    FileUtils.rm_rf('plugins')
                end
                context "when called with default parameters" do
                    it "It has to download those plugins" do
                        silence_stream(STDOUT) do
                            Spigoter::CLI.update.call
                        end
                        expect(File.open("plugins/FirstJoinPlus.jar").size).to be_within(10000).of(52309)
                        expect(File.open("plugins/NeoPaintingSwitch.jar").size).to be_within(10000).of(13173)
                    end
                end
                context "when called with a list of plugins" do
                    it "update just those plugins" do
                        silence_stream(STDOUT) do
                            Spigoter::CLI.update.call({:list=>[:NeoPaintingSwitch]})
                        end
                        expect(File.open("plugins/NeoPaintingSwitch.jar").size).to be_within(10000).of(13173)
                    end
                end
                context "with an error in spigoter.yml" do
                    before :each do
                        open('plugins.yml', 'a+') { |f|
                            f << "  CheeseMaker:\n"
                            f << "    url: \"http://dev.bukkit.org/bukkit-plugins/cheesemaker/\"\n"
                            f << "    type: \"ajlksdjhasjd\"\n"
                        }
                    end
                    it "logs and error and continues" do
                        silence_stream(STDOUT) do
                            expect{Spigoter::CLI.update.call}.to raise_error SystemExit
                        end
                        expect(@log_output.readline).to eq " INFO  Spigoter : Updating!\n"
                        expect(@log_output.readline).to eq " INFO  Spigoter : Updating plugin: FirstJoinPlus\n"
                        expect(@log_output.readline).to eq " INFO  Spigoter : Updating plugin: NeoPaintingSwitch\n"
                        expect(@log_output.readline).to eq " INFO  Spigoter : Updating plugin: CheeseMaker\n"
                        expect(@log_output.readline).to eq "ERROR  Spigoter : Plugin type ajlksdjhasjd doesn't exists!\n"
                        expect(File.open("plugins/FirstJoinPlus.jar").size).to be_within(10000).of(52309)
                        expect(File.open("plugins/NeoPaintingSwitch.jar").size).to be_within(10000).of(13173)
                    end
                end
                context "if there is no internet" do
                    before :each do
                        allow(Spigoter::Utils).to receive(:open).and_raise(SocketError)
                    end
                    it "logs and error and continues" do
                        silence_stream(STDOUT) do
                            Spigoter::CLI.update.call
                        end
                        expect(@log_output.readline).to eq " INFO  Spigoter : Updating!\n"
                        expect(@log_output.readline).to eq " INFO  Spigoter : Updating plugin: FirstJoinPlus\n"
                        expect(@log_output.readline).to eq "ERROR  Spigoter : Can't download anything from http://mods.curse.com/bukkit-plugins/minecraft/firstjoinplus, check internet or URL?\n"
                        expect(@log_output.readline).to eq " INFO  Spigoter : Updating plugin: NeoPaintingSwitch\n"
                        expect(@log_output.readline).to eq "ERROR  Spigoter : Can't download anything from http://dev.bukkit.org/bukkit-plugins/paintingswitch, check internet or URL?\n"
                    end
                end
            end
            context "but plugins dir doesn't" do
                it "logs and error and continue" do
                    silence_stream(STDOUT) do
                        expect{Spigoter::CLI.update.call}.to raise_error SystemExit
                    end
                    expect(@log_output.readline).to eq " INFO  Spigoter : Updating!\n"
                    expect(@log_output.readline).to eq "ERROR  Spigoter : plugins directory doesn't exists, please, create it\n"
                end
            end
        end
        context "if plugins.yml doesn't exists" do
            it "logs an error and exit" do
                silence_stream(STDOUT) do
                    expect{Spigoter::CLI.update.call}.to raise_error SystemExit
                end
                expect(@log_output.readline).to eq " INFO  Spigoter : Updating!\n"
                expect(@log_output.readline).to eq "ERROR  Spigoter : plugins.yml doesn't exists, please, create one (you can use spigoter init)\n"
            end
        end

#         describe "updating all plugins" do
#             before :each do
#             end
#             after :each do
#                 FileUtils.rm_rf(Dir.glob("*"))
#             end
#             xit "With default parameters, " do
#                 Spigoter::CLI.update.call({})
#                 expect(File.open("plugins/Authme.jar").size).to be_within(10000).of(1796785)
#                 expect(File.open("plugins/BossShop.jar").size).to be_within(10000).of(195800)
#                 expect(File.open("plugins/Dynmap.jar").size).to be_within(10000).of(4102422)
#             end
#             xit "With a list with specific plugins, " do
#                 Spigoter::CLI.update.call({:list=>["Authme", "BossShop"]})
#                 expect(File.open("plugins/Authme.jar").size).to be_within(10000).of(1796785)
#                 expect(File.open("plugins/BossShop.jar").size).to be_within(10000).of(195800)
#                 expect(File.exist?("plugins/Dynmap.jar")).to be false
#             end
#             xit "If no plugins.yml is found, exit with 1" do
#                 FileUtils.rm('plugins.yml')
#                 expect{Spigoter::CLI.update.call({})}.to raise_error SystemExit
#             end
#             xit "If no plugins dir is found, exit with 1" do
#                 FileUtils.rm_rf('plugins')
#                 expect{Spigoter::CLI.update.call({})}.to raise_error SystemExit
#             end
#             xit "Log an error if type is Unkown" do
#                 yml = File.open("plugins.yml", 'wb')
#                 yml.write('
# Authme:
#   url: "http://mods.curse.com/bukkit-plugins/minecraft/authme-reloaded"
#   type: "aksjdhaksjd"')
#                 yml.close
#                 Spigoter::CLI.update.call({})
#                 expect(@log_output.readline).to eq " INFO  Spigoter : Updating!\n"
#                 expect(@log_output.readline).to eq " INFO  Spigoter : Starting to download Authme\n"
#                 expect(@log_output.readline).to eq "ERROR  Spigoter : Unkown source aksjdhaksjd\n"
#             end
#         end
    end
end
