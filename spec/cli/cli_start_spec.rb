describe Spigoter::CLI do
    describe "#start" do
        before :all do
            Dir.chdir('tmp')
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
            it "if java doesn't exists, log an error" do
                allow(Spigoter::Utils).to receive(:which).and_return(nil)
                expect(Spigoter::Utils.which('java')).to be nil
                Spigoter::CLI.run('start')
                expect(@log_output.readline).to eq "ERROR  Spigoter : You don't have java in PATH\n"
            end
        end
    end
end
