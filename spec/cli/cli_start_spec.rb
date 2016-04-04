describe Spigoter::CLI do
    describe "#start" do
        before :all do
            Dir.chdir('tmp')
            Spigoter::CLI::Init.main
            Spigoter::CLI::Compile.main
        end
        after :all do
            FileUtils.rm_rf(Dir.glob("*"))
            Dir.chdir('..')
        end
        describe "when starting the server" do
            it "should start, the first time creates the eula.txt" do
                expect(File.exist?("eula.txt")).to be false
                Spigoter::CLI.run('start')
                expect(File.exist?("eula.txt")).to be true
            end
            it "if java doesn't exists, log an error and exit" do
                allow(Spigoter::Utils).to receive(:which).and_return(nil)
                expect(Spigoter::Utils.which('java')).to be nil
                expect{Spigoter::CLI.run('start')}.to raise_error SystemExit
                expect(@log_output.readline).to eq "ERROR  Spigoter : You don't have java in PATH\n"
            end
            it "if spigoter.yml doesn't exists, log an error and exit" do
                FileUtils.rm_rf('spigoter.yml')
                expect{Spigoter::CLI.run('start')}.to raise_error SystemExit
                expect(@log_output.readline).to eq "ERROR  Spigoter : spigoter.yml doesn't exists, do 'spigoter init'\n"
            end
        end
    end
end
