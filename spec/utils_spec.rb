require "spec_helper"
require "fileutils"

describe Spigoter::Utils do
    describe "#download" do
        it "downloads the file correctly" do
            file = Spigoter::Utils.download('http://example.com')
            expect(file.size).to be_within(100).of(1270)
        end
        context "without an internet connection" do
            before :each do
                allow(Spigoter::Utils).to receive(:open).and_raise(SocketError)
            end
            it "raises an error" do
                expect{Spigoter::Utils.download('http://example.com')}
                .to raise_error(RuntimeError, "Can't download anything from http://example.com, check internet or URL?")
            end
        end
    end

    describe "#loadyaml" do
        context "if the file exists" do
            before :each do
                FileUtils.touch('spigoter.yml')
            end
            after :each do
                FileUtils.rm('spigoter.yml')
            end
            context "and it's well formated" do
                before :each do
                    open('spigoter.yml', 'w+') { |f|
                        f << "Root:\n"
                        f << "  Child: true\n"
                        f << "  Child2: false\n"
                    }
                end
                it "returns the yaml serialized into a hash" do
                    hash = Spigoter::Utils.loadyaml('spigoter.yml')
                    expect(hash).to eq({"Root"=>{"Child"=>true, "Child2"=>false}})
                end
            end
            context "if it's bad formed" do
                before :each do
                    open('spigoter.yml', 'w+') { |f|
                        f << "I'm an\n"
                        f << "Very malfor\n"
                        f << "Med YAML file!!-%&/\n"
                    }
                end
                it "raises an error" do
                    expect{Spigoter::Utils.loadyaml('spigoter.yml')}
                    .to raise_error "Malformed YAML file spigoter.yml"
                end
            end
        end
        context "if file doesn't exists" do
            it "raises an error" do
                expect{Spigoter::Utils.loadyaml('spigoter.yml')}
                .to raise_error(RuntimeError, "File spigoter.yml doesn't exists")
            end
        end
    end

    describe "#which" do
        context "if the program exists" do
            it "returns its path" do
                expect(Spigoter::Utils.which('cat')).to eq '/bin/cat'
            end
        end
        context "if doesn't exists" do
            it "returns nil" do
                expect(Spigoter::Utils.which('catasdasd')).to be nil
            end
        end
    end

    describe "#symbolize" do
        context "if we have a hash with strings as symbols" do
            before :each do
                @hash = {
                    'one' => [1, 2],
                    'two' => [1, 2, 3],
                    'four' => [1, 2, 3, 4]
                }
            end
            it "returns the hash with symbols" do
                symbolized = {
                    :one => [1, 2],
                    :two => [1, 2, 3],
                    :four => [1, 2, 3, 4]
                }
                expect(Spigoter::Utils.symbolize(@hash)).to eq symbolized
            end
        end
        context "if the hash has already symbols" do
            before :each do
                @hash = {
                    :one => [1, 2],
                    :two => [1, 2, 3],
                    :four => [1, 2, 3, 4]
                }
            end
            it "returns the same hash" do
                symbolized = {
                    :one => [1, 2],
                    :two => [1, 2, 3],
                    :four => [1, 2, 3, 4]
                }
                expect(Spigoter::Utils.symbolize(@hash)).to eq symbolized
            end
        end
    end

    describe "#fill_opts_config" do
        before :all do
            Dir.chdir('tmp')
        end
        after :all do
            Dir.chdir('..')
        end
        context "if there is no spigoter.yml" do
            it "raises an error" do
                expect{Spigoter::Utils.fill_opts_config}.to raise_error RuntimeError, "spigoter.yml doesn't exists, do 'spigoter init'"
            end
        end
        context "if spigoter.yml exists" do
            context "with a normal spigoter.yml" do
                before :each do
                    open('spigoter.yml', 'w+') { |f|
                        f << "---\n"
                        f << "Spigoter:\n"
                        f << "  build_dir: build\n"
                        f << "  plugins_dir: plugins\n"
                        f << "  javaparams: '-Xms1G -Xmx2G'\n"
                        f << "  spigot_version: 1.9.2\n"
                    }
                end
                after :each do
                    FileUtils.rm('spigoter.yml')
                end
                it "returns a hash with the options" do
                    expect(Spigoter::Utils.fill_opts_config).to eq({
                        :build_dir=>"build",
                        :plugins_dir=>"plugins",
                        :javaparams=>"-Xms1G -Xmx2G",
                        :spigot_version => "1.9.2"
                    })
                end
            end
            context "if there are missing some rows" do
                before :each do
                    open('spigoter.yml', 'w+') { |f|
                        f << "---\n"
                        f << "Spigoter:\n"
                    }
                end
                after :each do
                    FileUtils.rm('spigoter.yml')
                end
                it "return a hash with the keys filled with the missing columns" do
                    expect(Spigoter::Utils.fill_opts_config).to eq({
                        :build_dir=>"build",
                        :plugins_dir=>"plugins",
                        :javaparams=>"-Xms1G -Xmx2G",
                        :spigot_version => Spigoter::SPIGOT_VERSION
                    })
                end
            end
        end
    end
    describe "#default_opts" do
        context "if we have an empty hash" do
            it "returns the hash with the default opts setted" do
                expect(Spigoter::Utils.default_opts({})).to eq({
                    :build_dir=>"build",
                    :plugins_dir=>"plugins",
                    :javaparams=>"-Xms1G -Xmx2G",
                    :spigot_version => Spigoter::SPIGOT_VERSION
                })
            end
        end
        context "if we have a partial hash" do
            it "returns the hash with the default opts and the customs setted" do
                expect(Spigoter::Utils.default_opts({
                    :build_dir=>"bld",
                    :plugins_dir=>"plg",
                })).to eq({
                    :build_dir=>"bld",
                    :plugins_dir=>"plg",
                    :javaparams=>"-Xms1G -Xmx2G",
                    :spigot_version => Spigoter::SPIGOT_VERSION
                })
            end
        end
        context "if we have a hash with all the settigns" do
            it "returns the same hash" do
                expect(Spigoter::Utils.default_opts({
                    :build_dir=>"bld",
                    :plugins_dir=>"plg",
                    :javaparams=>"-Xms1G -Xmx2G -d64",
                    :spigot_version => "1.8"
                })).to eq({
                    :build_dir=>"bld",
                    :plugins_dir=>"plg",
                    :javaparams=>"-Xms1G -Xmx2G -d64",
                    :spigot_version => "1.8"
                })
            end
        end
    end
end
