require 'spec_helper'

describe Spigoter::CLI, '#init' do
  before :all do
    Dir.chdir('tmp')
  end
  after :all do
    Dir.chdir('..')
  end
  after :each do
    File.delete('plugins.yml')
    File.delete('spigoter.yml')
  end
  context 'by default' do
    it 'writes spigot.yml and plugins.yml and populates them' do
      silence_stream(STDOUT) do
        Spigoter::CLI.init.call
      end
      plugins_data = Spigoter::Utils.loadyaml('plugins.yml')
      config_data = Spigoter::Utils.loadyaml('spigoter.yml')
      expect(plugins_data).to eq('Plugins' => nil)
      expect(config_data).to eq('Spigoter' => {
                                  'build_dir' => 'build',
                                  'plugins_dir' => 'plugins',
                                  'javaparams' => '-Xms1G -Xmx2G',
                                  'spigot_version' => 'latest'
                                }
                               )
    end
  end
  context 'if detects plugins in plugins dir with plugins inside' do
    before :each do
      Dir.mkdir('plugins')
      FileUtils.touch('plugins/AuthMe.jar')
      FileUtils.touch('plugins/Dynmap.jar')
      FileUtils.touch('plugins/Vault.jar')
      FileUtils.touch('plugins/Essentials.jar')
    end
    after :each do
      FileUtils.rm_r('plugins')
    end
    it 'adds them to the plugins.yml' do
      silence_stream(STDOUT) do
        Spigoter::CLI.init.call
      end
      plugins_data = Spigoter::Utils.loadyaml('plugins.yml')
      config_data = Spigoter::Utils.loadyaml('spigoter.yml')
      expect(plugins_data).to eq('Plugins'  => {
                                   'Dynmap' => nil,
                                   'AuthMe' => nil,
                                   'Vault' => nil,
                                   'Essentials' => nil
                                 }
                                )
      expect(config_data).to eq('Spigoter' => {
                                  'build_dir' => 'build',
                                  'plugins_dir' => 'plugins',
                                  'javaparams' => '-Xms1G -Xmx2G',
                                  'spigot_version' => 'latest'
                                }
                               )
    end
  end
  context 'if there is a plugins dir, but is empty' do
    before :each do
      Dir.mkdir('plugins')
    end
    after :each do
      FileUtils.rm_r('plugins')
    end
    it 'adds them to the plugins.yml' do
      silence_stream(STDOUT) do
        Spigoter::CLI.init.call
      end
      plugins_data = Spigoter::Utils.loadyaml('plugins.yml')
      config_data = Spigoter::Utils.loadyaml('spigoter.yml')
      expect(plugins_data).to eq('Plugins' => nil)
      expect(config_data).to eq('Spigoter' => {
                                  'build_dir' => 'build',
                                  'plugins_dir' => 'plugins',
                                  'javaparams' => '-Xms1G -Xmx2G',
                                  'spigot_version' => 'latest'
                                }
                               )
    end
  end
  context 'if plugins.yml already exists' do
    before :each do
      FileUtils.touch('plugins.yml')
    end
    it 'log a warning' do
      silence_stream(STDOUT) do
        Spigoter::CLI.init.call
      end
      expect(@log_output.readline).to eq " INFO  Spigoter : Generating files!\n"
      expect(@log_output.readline).to eq " WARN  Spigoter : plugins.yml alredy exists\n"
    end
  end
  context 'if spigoter.yml already exists' do
    before :each do
      FileUtils.touch('spigoter.yml')
    end
    it 'If spigoter.yml already exists, log a warning' do
      silence_stream(STDOUT) do
        Spigoter::CLI.init.call
      end
      expect(@log_output.readline).to eq " INFO  Spigoter : Generating files!\n"
      expect(@log_output.readline).to eq " WARN  Spigoter : spigoter.yml alredy exists\n"
    end
  end
end
