require 'spec_helper'

describe Spigoter::CLI, "#compile" do
    before :all do
        Dir.chdir('tmp')
    end
    after :all do
        Dir.chdir('..')
    end
    context "if exists spigoter.yml and java and git are in PATH" do
        before :each do
            Spigoter::CLI::Init.main
        end
        after :each do
            FileUtils.rm_f("plugins.yml")
            FileUtils.rm_f("spigoter.yml")
            FileUtils.rm_rf("build")
        end
        it "It has to create the latest spigot.jar" do
            silence_stream(STDOUT) do
                Spigoter::CLI::Compile.compile.call
            end
            expect(File.exist?('spigot.jar')).to be true
        end
        context "but an error occurs while compiling spigot" do
            before :each do
                allow(Spigoter::CLI::Compile).to receive(:system).and_return(nil)
            end
            it "aborts the execution" do
                silence_stream(STDOUT) do
                    expect{Spigoter::CLI::Compile.compile.call}.to raise_error SystemExit
                end
            end
        end
    end

    context "if there isn't a spigoter.yml" do
        it "aborts the execution" do
            silence_stream(STDOUT) do
                expect{Spigoter::CLI::Compile.main}.to raise_error SystemExit
            end
            expect(@log_output.readline).to eq "ERROR  Spigoter : There is an error in spigoter.yml\n"
        end
    end

    context "If java or git doesn't exists" do
        before :each do
            allow(Spigoter::Utils).to receive(:which).and_return(nil)
        end
        it "aborts the execution" do
            silence_stream(STDOUT) do
                expect{Spigoter::CLI::Compile.validate_deps}.to raise_error SystemExit
            end
            expect(@log_output.readline).to eq "ERROR  Spigoter : You don't have javac or git in PATH\n"
        end
    end
end
