require 'spec_helper'
require 'fileutils'

describe Spigoter::Utils do
  describe '#download' do
    it 'downloads the file correctly' do
      file = Spigoter::Utils.download('http://example.com')
      expect(file.size).to be_within(100).of(1270)
    end
    context 'without an internet connection' do
      before :each do
        allow(Spigoter::Utils).to receive(:open).and_raise(SocketError)
      end
      it 'raises an error' do
        expect { Spigoter::Utils.download('http://example.com') }
            .to raise_error(RuntimeError, "Can't download anything from http://example.com, check internet or URL?")
      end
    end
  end
end

describe Spigoter::Utils do
  describe '#loadyaml' do
    context 'if the file exists' do
      before :each do
        FileUtils.touch('spigoter.yml')
      end
      after :each do
        File.delete('spigoter.yml')
      end
      context "and it's well formated" do
        before :each do
          File.open('spigoter.yml', 'w+') do |f|
            f << "Root:\n"
            f << "  Child: true\n"
            f << "  Child2: false\n"
          end
        end
        it 'returns the yaml serialized into a hash' do
          hash = Spigoter::Utils.loadyaml('spigoter.yml')
          expect(hash).to eq('Root' => { 'Child' => true, 'Child2' => false })
        end
      end
      context "if it's bad formed" do
        before :each do
          open('spigoter.yml', 'w+') do |f|
            f << "I'm an\n"
            f << "Very malfor\n"
            f << "Med YAML file!!-%&/\n"
          end
        end
        it 'raises an error' do
          expect { Spigoter::Utils.loadyaml('spigoter.yml') }
              .to raise_error 'Malformed YAML file spigoter.yml'
        end
      end
    end
    context "if file doesn't exists" do
      it 'raises an error' do
        expect { Spigoter::Utils.loadyaml('spigoter.yml') }
            .to raise_error(RuntimeError, "File spigoter.yml doesn't exists")
      end
    end
  end
end

describe Spigoter::Utils do
  describe '#which' do
    context 'if the program exists' do
      it 'returns its path' do
        expect(Spigoter::Utils.which('java')).not_to be_nil
      end
    end
    context "if doesn't exists" do
      it 'returns nil' do
        expect(Spigoter::Utils.which('catasdasd')).to be nil
      end
    end
  end
end

describe Spigoter::Utils do
  describe '#symbolize' do
    context 'if we have a hash with strings as symbols' do
      context 'with simple quotes' do
        before :each do
          @hash = {
              'one' => [1, 2],
              'two' => [1, 2, 3],
              'four' => [1, 2, 3, 4]
          }
        end
        it 'returns the hash with symbols' do
          symbolized = {
              one: [1, 2],
              two: [1, 2, 3],
              four: [1, 2, 3, 4]
          }
          expect(Spigoter::Utils.symbolize(@hash)).to eq symbolized
        end
      end
      context 'with double quotes' do
        before :each do
          @hash = {
              'url' => 'http://mods.curse.com/bukkit-plugins/minecraft/firstjoinplus',
              'type' => 'curse'
          }
        end
        it 'returns the hash with symbols' do
          symbolized = {
              url: 'http://mods.curse.com/bukkit-plugins/minecraft/firstjoinplus',
              type: 'curse'
          }
          expect(Spigoter::Utils.symbolize(@hash)).to eq symbolized
        end
      end
    end
    context 'if the hash has already symbols' do
      before :each do
        @hash = {
            one: [1, 2],
            two: [1, 2, 3],
            four: [1, 2, 3, 4]
        }
      end
      it 'returns the same hash' do
        symbolized = {
            one: [1, 2],
            two: [1, 2, 3],
            four: [1, 2, 3, 4]
        }
        expect(Spigoter::Utils.symbolize(@hash)).to eq symbolized
      end
    end
  end

  describe '#fill_opts_config' do
    before :all do
      Dir.chdir('tmp')
    end
    after :all do
      Dir.chdir('..')
    end
    context 'if there is no spigoter.yml' do
      it 'raises an error' do
        expect { Spigoter::Utils.fill_opts_config }
            .to raise_error RuntimeError, "spigoter.yml doesn't exists, do 'spigoter init'"
      end
    end
    context 'if spigoter.yml exists' do
      context 'with a normal spigoter.yml' do
        before :each do
          open('spigoter.yml', 'w+') do |f|
            f << "---\n"
            f << "Spigoter:\n"
            f << "  build_dir: build\n"
            f << "  plugins_dir: plugins\n"
            f << "  javaparams: \"-Xms1G -Xmx2G\"\n"
            f << "  spigot_version: 1.9.2\n"
          end
        end
        after :each do
          File.delete('spigoter.yml')
        end
        it 'returns a hash with the options' do
          expect(Spigoter::Utils.fill_opts_config).to eq(
                                                          build_dir: 'build',
                                                          plugins_dir: 'plugins',
                                                          javaparams: '-Xms1G -Xmx2G',
                                                          spigot_version: '1.9.2'
                                                      )
        end
      end
      context 'if there are missing some rows' do
        before :each do
          open('spigoter.yml', 'w+') do |f|
            f << "---\n"
            f << "Spigoter:\n"
          end
        end
        after :each do
          FileUtils.rm_f('spigoter.yml')
        end
        it 'return a hash with the keys filled with the missing columns' do
          expect(Spigoter::Utils.fill_opts_config).to eq(
                                                          build_dir: 'build',
                                                          plugins_dir: 'plugins',
                                                          javaparams: '-Xms1G -Xmx2G',
                                                          spigot_version: Spigoter::SPIGOT_VERSION
                                                      )
        end
      end
    end
  end

  describe '#default_opts' do
    context 'if we have an empty hash' do
      it 'returns the hash with the default opts setted' do
        expect(Spigoter::Utils.default_opts({})).to eq(
                                                        build_dir: 'build',
                                                        plugins_dir: 'plugins',
                                                        javaparams: '-Xms1G -Xmx2G',
                                                        spigot_version: Spigoter::SPIGOT_VERSION
                                                    )
      end
    end
    context 'if we have a partial hash' do
      it 'returns the hash with the default opts and the customs setted' do
        expect(Spigoter::Utils.default_opts(build_dir: 'bld',
                                            plugins_dir: 'plg'))
            .to eq(build_dir: 'bld',
                   plugins_dir: 'plg',
                   javaparams: '-Xms1G -Xmx2G',
                   spigot_version: Spigoter::SPIGOT_VERSION
                )
      end
    end
    context 'if we have a hash with all the settigns' do
      it 'returns the same hash' do
        expect(
            Spigoter::Utils.default_opts(build_dir: 'bld',
                                         plugins_dir: 'plg',
                                         javaparams: '-Xms1G -Xmx2G -d64',
                                         spigot_version: '1.8'))
            .to eq(build_dir: 'bld',
                   plugins_dir: 'plg',
                   javaparams: '-Xms1G -Xmx2G -d64',
                   spigot_version: '1.8'
                )
      end
    end
  end

  describe '#get_plugins' do
    context 'if exists plugins.yml' do
      before :all do
        File.open('plugins.yml', 'w+') do |f|
          f << "---\n"
          f << "Plugins:\n"
          f << "  FirstJoinPlus:\n"
          f << "    url: \"http://mods.curse.com/bukkit-plugins/minecraft/firstjoinplus\"\n"
          f << "    type: \"curse\"\n"
          f << "  NeoPaintingSwitch:\n"
          f << "    url: \"http://dev.bukkit.org/bukkit-plugins/paintingswitch\"\n"
          f << "    type: \"devbukkit\"\n"
        end
      end
      after :all do
        File.delete('plugins.yml')
      end
      context 'if called with default parameters' do
        it 'Returns the list of plugins, and its data' do
          data = Spigoter::Utils.get_plugins
          expect(data).to eq(
                              FirstJoinPlus: {
                                  url: 'http://mods.curse.com/bukkit-plugins/minecraft/firstjoinplus',
                                  type: :curse },
                              NeoPaintingSwitch: {
                                  url: 'http://dev.bukkit.org/bukkit-plugins/paintingswitch',
                                  type: :devbukkit }
                          )
        end
      end
      context 'if called with a list of plugins' do
        it 'Returns the list of plugins, and its data' do
          data = Spigoter::Utils.get_plugins(list: [:FirstJoinPlus])
          expect(data).to eq(
                              FirstJoinPlus: {
                                  url: 'http://mods.curse.com/bukkit-plugins/minecraft/firstjoinplus',
                                  type: :curse }
                          )
        end
      end
    end
    context "if plugins.yml doesn't exist" do
      it 'raises an error' do
        expect { Spigoter::Utils.get_plugins(list: [:FirstJoinPlus]) }.to raise_error(RuntimeError)
      end
    end
  end
end
