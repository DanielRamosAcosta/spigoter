require 'spec_helper'

describe Spigoter::CLI do
	describe "#compile" do
		before :all do
			Dir.chdir('tmp')
		end
		before :each do
			FileUtils.rm_rf(Dir.glob("spigot.jar"))
		end
		after :all do
			FileUtils.rm_rf(Dir.glob("*"))
			Dir.chdir('..')
		end
		describe "When is compiled with default parameters" do
			it "It has to create the correct spigot.jar" do
				Spigoter::CLI.run('compile', {:version=>'1.9'})
				expect(File.exist?('spigot.jar')).to be true
			end
		end
		describe "When is compiled with specific version" do
			it "It has to create the correct spigot.jar" do
				Spigoter::CLI.run('compile', {:version=>'1.9'})
				expect(File.open("spigot.jar").size).to be_within(10000).of(20503413)
			end
			it "If BuildTools.jar alredy exists, it skips the download" do
				allow(Spigoter::Utils).to receive(:open).and_raise(SocketError)
				# If there is a BuildTools.jar alredy, it shouldnt fail if there is no internet
				expect{Spigoter::Utils.download('http://humanstxt.org/humans.txt')}.to raise_error(RuntimeError, "Can't download anything from http://humanstxt.org/humans.txt, check internet?")
				Spigoter::CLI.run('compile', {:version=>'1.9'})
				expect(File.open("spigot.jar").size).to be_within(10000).of(20503413)
			end
		end
		describe "If java or git isn't in PATH" do
			it "It should end with an error" do
				allow(Spigoter::Utils).to receive(:which).and_return(nil)
				expect(Spigoter::Utils.which('java')).to be nil
				expect(Spigoter::Utils.which('git')).to be nil
				Spigoter::CLI.run('compile')
				expect(@log_output.readline).to eq "ERROR  Spigoter : You don't have java or git in PATH\n"
			end
		end
	end
end