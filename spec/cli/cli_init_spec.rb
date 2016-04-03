require 'spec_helper'

describe Spigoter::CLI do
	describe "#init" do
		before :all do
			Dir.chdir('tmp')
		end
		after :each do
		    FileUtils.rm_rf(Dir.glob("*"))
		end
		after :all do
			Dir.chdir('..')
		end
		describe "When init is called" do
			it "It has to create the correct spigot.yml and plugins.yml" do
				Spigoter::CLI.run('init')
				plugins_data = YAML.load(File.read('plugins.yml'))
				config_data = YAML.load(File.read('spigoter.yml'))
				expect(plugins_data).to eq({'Plugins'=> nil})
				expect(config_data).to eq({"Spigoter"=>{"build_dir"=>"build", "plugins_dir"=>"plugins", "javaparams"=>"-Xms1G -Xmx2G"}})
			end
			it "If there are already plugins, add those to plugins.yml" do
			    Dir.mkdir('plugins')
			    File.open('plugins/AuthMe.jar', 'w')
			    File.open('plugins/Dynmap.jar', 'w')
			    File.open('plugins/Vault.jar', 'w')
			    File.open('plugins/Essentials.jar', 'w')
				Spigoter::CLI.run('init')
				plugins_data = YAML.load(File.read('plugins.yml'))
				config_data = YAML.load(File.read('spigoter.yml'))
				expect(plugins_data).to eq({"Plugins"=>{"Dynmap"=>nil, "AuthMe"=>nil, "Vault"=>nil, "Essentials"=>nil}})
				expect(config_data).to eq({"Spigoter"=>{"build_dir"=>"build", "plugins_dir"=>"plugins", "javaparams"=>"-Xms1G -Xmx2G"}})
			end
		end
	end
end