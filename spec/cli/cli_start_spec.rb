describe Spigoter::CLI do
	describe "#compile" do
		describe "compiling spigot" do
			before :all do
				# Compile spigot
			end
			it "With default parameters, " do
				Spigoter::CLI.run('start')
			end
		end
	end
end