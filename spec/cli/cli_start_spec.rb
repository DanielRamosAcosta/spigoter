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
      FileUtils.rm_rf('plugins.yml')
      FileUtils.rm_rf('spigoter.yml')
      Dir.chdir('..')
    end
    context 'if is the first time' do
      after :each do
        FileUtils.rm_rf('build')
        FileUtils.rm_rf('logs')
        FileUtils.rm_rf('eula.txt')
        FileUtils.rm_rf('server.properties')
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
        FileUtils.rm_rf('spigoter.yml')
        silence_stream(STDOUT) do
          expect { Spigoter::CLI.start.call }.to raise_error SystemExit
        end
        expect(@log_output.readline).to eq " INFO  Spigoter : Starting the server!\n"
        expect(@log_output.readline).to eq "ERROR  Spigoter : spigoter.yml doesn't exists, do 'spigoter init'\n"
      end
    end
  end
end
