require "spec_helper"
require "fileutils"

describe Spigoter::Utils do
    describe "#download" do
        xit "It downloads the file correctly" do
            file = Spigoter::Utils.download('http://example.com')
            expect(file.size).to be_within(100).of(1270)
        end
        xit "If there is no internet, then raise an error" do
            allow(Spigoter::Utils).to receive(:open).and_raise(SocketError)
            expect{Spigoter::Utils.download('http://example.com')}.to raise_error(RuntimeError, "Can't download anything from http://example.com, check internet?")
        end
    end
    describe "#which" do
        xit "If that program exists, then true" do
            expect(Spigoter::Utils.which('cat')).to eq '/bin/cat'
        end
        xit "In other case, false" do
            expect(Spigoter::Utils.which('catasdasd')).to be nil
        end
    end

    describe "#symbolize!" do
        xit "Given an hash with strings as keys, it has to convert to symbols" do
            hash = {
                'something' => 'dummy',
                'Other' => 26,
                'lulz' => [
                    1,
                    2,
                    3
                ]
            }
            hash = Spigoter::Utils::symbolize(hash)
            expect(hash). to eq({
                :something => 'dummy',
                :Other => 26,
                :lulz => [
                    1,
                    2,
                    3
                ]
            })
        end
    end

    describe "#fill_opts_config" do
        before :all do
            Dir.chdir('tmp')
        end
        after :all do
            Dir.chdir('..')
        end
        after :each do
            FileUtils.rm_rf(Dir.glob("*"))
        end

        xit "If there is no spigoter.yml log error and exit" do
            expect{Spigoter::Utils.fill_opts_config}.to raise_error RuntimeError, "spigoter.yml doesn't exists, do 'spigoter init'"
        end
        xit "With some params missing, it has to fill them" do
            config = {
                'Spigoter' => {
                    'build_dir' => 'build',
                    'plugins_dir' => 'plugins',
                    'javaparams' => '-Xms1G -Xmx2G'
                }
            }
            yml = File.open("spigoter.yml", 'wb')
            yml.write(config.to_yaml)
            yml.close
            expect(Spigoter::Utils.fill_opts_config).to eq({:build_dir=>"build", :plugins_dir=>"plugins", :javaparams=>"-Xms1G -Xmx2G", :spigot_version => Spigoter::SPIGOT_VERSION})
        end
    end
end
