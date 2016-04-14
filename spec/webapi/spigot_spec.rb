require 'spec_helper'
require 'fileutils'

describe Spigoter::PluginSpigot, '#initialize' do
  context 'with a valid URL' do
    it 'creates the object' do
      pln = Spigoter::PluginSpigot.new('https://www.spigotmc.org/resources/nametags.13119/')
      expect(pln.class.to_s).to eq('Spigoter::PluginSpigot')
    end
    context 'but without an internet connection' do
      before :each do
        allow(Spigoter::Utils).to receive(:open).and_raise(SocketError)
      end
      it 'raises an error' do
        expect { Spigoter::PluginSpigot.new('https://www.spigotmc.org/resources/nametags.13119/') }
          .to raise_error "Can't download anything from https://www.spigotmc.org/resources/nametags.13119/, "\
          'check internet or URL?'
      end
    end
  end
  context 'with a wrong URL' do
    it 'raises an error' do
      expect { Spigoter::PluginSpigot.new('https://www.spigotmc.org/resources/') }
        .to raise_error 'Bad URL https://www.spigotmc.org/resources/'
    end
    it 'raises an error' do
      expect { Spigoter::PluginSpigot.new('https://www.spigotmc.org/resources/???') }
        .to raise_error 'Bad URL https://www.spigotmc.org/resources/???'
    end
    it 'raises an error' do
      expect { Spigoter::PluginSpigot.new('https://www.spigotmc.org/resources/kahdkjhaskdhaskdha.123/') }
        .to raise_error "Can't download anything from https://www.spigotmc.org/resources/kahdkjhaskdhaskdha.123/, "\
        'check internet or URL?'
    end
  end
end

describe Spigoter::PluginSpigot do
  before :each do
    @plugin = Spigoter::PluginSpigot.new('https://www.spigotmc.org/resources/nametags.13119/')
  end
  describe '#version' do
    it 'returns current version' do
      expect(@plugin.version).to eq('1.1')
    end
  end
  describe '#name' do
    it 'returns the plugin name' do
      expect(@plugin.name).to eq('Nametags')
    end
  end
  describe '#file' do
    it 'returns the file (myPlugin.jar)' do
      expect(@plugin.file.size).to be_within(10_000).of(14_695)
      # +-1M from the original, if the author updates the plugin...
    end
  end
end
