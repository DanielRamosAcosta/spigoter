require 'spec_helper'

describe Spigoter::CLI do
    describe "#compile" do
        before :all do
            Dir.chdir('tmp')
        end
        before :each do
            Spigoter::CLI::Init.main
            FileUtils.rm_rf(Dir.glob("spigot.jar"))
        end
        after :all do
            FileUtils.rm_rf(Dir.glob("*"))
            Dir.chdir('..')
        end
        describe "When is compiled with default parameters" do
            it "It has to create the latest spigot.jar" do
                Spigoter::CLI::Compile.main
                expect(File.exist?('spigot.jar')).to be true
            end
                it "If BuildTools.jar alredy exists, it skips the download" do
                allow(Spigoter::Utils).to receive(:open).and_raise(SocketError)
                # If there is a BuildTools.jar alredy, it shouldnt fail if there is no internet
                expect{Spigoter::Utils.download('http://humanstxt.org/humans.txt')}.to raise_error(RuntimeError, "Can't download anything from http://humanstxt.org/humans.txt, check internet?")
                Spigoter::CLI::Compile.main
                expect(File.exist?('spigot.jar')).to be true
            end
        end
    end

    describe "#validate_deps" do
        it "If java and git exists, continue the execution" do
            expect(Spigoter::CLI::Compile.validate_deps).to be true
        end
        it "If java or git doesn't exists, abort the execution" do
            allow(Spigoter::Utils).to receive(:which).and_return(nil)
            expect{Spigoter::CLI::Compile.validate_deps}.to raise_error SystemExit
            expect(@log_output.readline).to eq "ERROR  Spigoter : You don't have java or git in PATH\n"
        end
    end
end
