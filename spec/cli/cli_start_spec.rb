describe Spigoter::CLI do
  describe '#start' do
    before :all do
      Dir.chdir('tmp')
      silence_stream(STDOUT) do
        Spigoter::CLI.init.call
      end
      Spigoter::CLI::Compile.main unless File.exist?('spigot.jar')
    end
    after :all do
      File.delete('plugins.yml') if File.exist?('plugins.yml')
      File.delete('spigoter.yml') if File.exist?('spigoter.yml')
      Dir.chdir('..')
    end
    context 'if is the first time' do
      after :each do
        FileUtils.rm_r('build') if Dir.exist?('build')
        FileUtils.rm_r('logs')
        File.delete('eula.txt')
        File.delete('server.properties')
      end
      it 'creates eula.txt file' do
        expect(File.exist?('eula.txt')).to be false
        silence_stream(STDOUT) do
          Spigoter::CLI.start.call
        end
        expect(File.exist?('eula.txt')).to be true
      end
    end
    context "if java doesn't exists" do
      it 'log an error and exit' do
        allow(Spigoter::Utils).to receive(:which).and_return(nil)
        expect(Spigoter::Utils.which('java')).to be nil
        silence_stream(STDOUT) do
          expect { Spigoter::CLI.start.call }.to raise_error SystemExit
        end
        expect(@log_output.readline).to eq " INFO  Spigoter : Starting the server!\n"
        expect(@log_output.readline).to eq "ERROR  Spigoter : You don't have java in PATH\n"
      end
    end
    context "if spigoter.yml doesn't exists" do
      it 'log an error and exit' do
        File.delete('spigoter.yml')
        silence_stream(STDOUT) do
          expect { Spigoter::CLI.start.call }.to raise_error SystemExit
        end
        expect(@log_output.readline).to eq " INFO  Spigoter : Starting the server!\n"
        expect(@log_output.readline).to eq "ERROR  Spigoter : spigoter.yml doesn't exists, do 'spigoter init'\n"
      end
    end
  end
end
