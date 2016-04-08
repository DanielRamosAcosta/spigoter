require 'spec_helper'

describe Spigoter::CLI, "#init" do
    after :each do
        FileUtils.rm("plugins.yml")
        FileUtils.rm("spigoter.yml")
    end
    context "by default" do
        it "writes spigot.yml and plugins.yml and populates them" do
            Spigoter::CLI.run('init')
            plugins_data = YAML.load(File.read('plugins.yml'))
            config_data = YAML.load(File.read('spigoter.yml'))
            expect(plugins_data).to eq({'Plugins'=> nil})
            expect(config_data).to eq({"Spigoter"=>{"build_dir"=>"build", "plugins_dir"=>"plugins", "javaparams"=>"-Xms1G -Xmx2G", "spigot_version"=>"latest"}})
        end
    end
    context "if detects plugins in plugins dir with plugins inside" do
        before :each do
            Dir.mkdir('plugins')
            File.open('plugins/AuthMe.jar', 'w')
            File.open('plugins/Dynmap.jar', 'w')
            File.open('plugins/Vault.jar', 'w')
            File.open('plugins/Essentials.jar', 'w')
        end
        after :each do
            FileUtils.rm_rf("plugins")
        end
        it "adds them to the plugins.yml" do
            Spigoter::CLI.run('init')
            plugins_data = YAML.load(File.read('plugins.yml'))
            config_data = YAML.load(File.read('spigoter.yml'))
            expect(plugins_data).to eq({"Plugins"=>{"Dynmap"=>nil, "AuthMe"=>nil, "Vault"=>nil, "Essentials"=>nil}})
            expect(config_data).to eq({"Spigoter"=>{"build_dir"=>"build", "plugins_dir"=>"plugins", "javaparams"=>"-Xms1G -Xmx2G", "spigot_version"=>"latest"}})
        end
    end
    context "if there is a plugins dir, but is empty" do
        before :each do
            Dir.mkdir('plugins')
        end
        after :each do
            FileUtils.rm_rf("plugins")
        end
        it "adds them to the plugins.yml" do
            Spigoter::CLI.run('init')
            plugins_data = YAML.load(File.read('plugins.yml'))
            config_data = YAML.load(File.read('spigoter.yml'))
            expect(plugins_data).to eq({'Plugins'=> nil})
            expect(config_data).to eq({"Spigoter"=>{"build_dir"=>"build", "plugins_dir"=>"plugins", "javaparams"=>"-Xms1G -Xmx2G", "spigot_version"=>"latest"}})
        end
    end
    context "if plugins.yml already exists" do
        before :each do
            File.open('plugins.yml', 'w')
        end
        it "log a warning" do
            silence_stream(STDOUT) do
                Spigoter::CLI.run('init')
            end
            expect(@log_output.readline).to eq " WARN  Spigoter : plugins.yml alredy exists\n"
        end
    end
    context "if spigoter.yml already exists" do
        before :each do
            File.open('spigoter.yml', 'w')
        end
        it "If spigoter.yml already exists, log a warning" do
            silence_stream(STDOUT) do
                Spigoter::CLI.run('init')
            end
            expect(@log_output.readline).to eq " WARN  Spigoter : spigoter.yml alredy exists\n"
        end
    end
end
