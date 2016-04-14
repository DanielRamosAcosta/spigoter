require 'spec_helper'
require 'fileutils'

describe Spigoter::Plugin, '#initialize' do
  context 'with a valid URL' do
    it 'creates the object' do
      pln = Spigoter::Plugin.new('http://example.com/')
      expect(pln.class.to_s).to eq('Spigoter::Plugin')
    end
    context 'but without an internet connection' do
      before :each do
        allow(Spigoter::Utils).to receive(:open).and_raise(SocketError)
      end
      it 'raises an error' do
        expect { Spigoter::Plugin.new('http://example.com/') }
          .to raise_error "Can't download anything from http://example.com/, check internet or URL?"
      end
    end
  end
  context 'with a wrong URL' do
    it 'raises an error' do
      expect { Spigoter::Plugin.new('http://eajd2ms.caosd3/asdsd') }
        .to raise_error "Can't download anything from http://eajd2ms.caosd3/asdsd, check internet or URL?"
    end
  end
end

describe Spigoter::Plugin do
  before :each do
    @plugin = Spigoter::Plugin.new('http://textfiles.com/100/914bbs.txt')
  end
  describe '#file' do
    it 'returns the file in the @url' do
      expect(@plugin.file.size).to be_within(500).of(3968)
    end
  end
end

describe Spigoter::Plugin, '.list' do
  it 'returns a hash to all types of plugins' do
    expect(Spigoter::Plugin.list).to eq(
      curse: Spigoter::PluginCurse,
      devbukkit: Spigoter::PluginBukkit,
      spigot: Spigoter::PluginSpigot
    )
  end
end
