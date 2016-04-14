require 'spec_helper'

describe Spigoter::CLI::Run, '#initialize' do
  it 'creates the object' do
    silence_stream(STDOUT) do
      @runner = Spigoter::CLI::Run.new
    end
    expect(@runner.class.to_s).to eq('Spigoter::CLI::Run')
  end
end

describe Spigoter::CLI::Run, '#tasks' do
  before :all do
    silence_stream(STDOUT) do
      @runner = Spigoter::CLI::Run.new
    end
  end
  context 'when the command is init' do
    before :each do
      @command = 'init'
    end
    it 'returns a proc of the command' do
      silence_stream(STDOUT) do
        @scl = Spigoter::CLI.init.source_location
      end
      silence_stream(STDOUT) do
        expect(Spigoter::CLI.run(@command).source_location).to eq @scl
      end
    end
  end
  context 'when the command is compile' do
    before :each do
      @command = 'compile'
    end
    it 'returns a proc of the command' do
      silence_stream(STDOUT) do
        @scl = Spigoter::CLI.compile.source_location
      end
      silence_stream(STDOUT) do
        expect(Spigoter::CLI.run(@command).source_location).to eq @scl
      end
    end
  end
  context 'when the command is update' do
    before :each do
      @command = 'update'
    end
    it 'returns a proc of the command' do
      silence_stream(STDOUT) do
        @scl = Spigoter::CLI.update.source_location
      end
      silence_stream(STDOUT) do
        expect(Spigoter::CLI.run(@command).source_location).to eq @scl
      end
    end
  end
  context 'when the command is start' do
    before :each do
      @command = 'start'
    end
    it 'returns a proc of the command' do
      silence_stream(STDOUT) do
        @scl = Spigoter::CLI.start.source_location
      end
      silence_stream(STDOUT) do
        expect(Spigoter::CLI.run(@command).source_location).to eq @scl
      end
    end
  end
end
