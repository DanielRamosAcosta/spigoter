require 'spec_helper'

describe Spigoter::CLI do
	describe "#main" do
		describe "executing the server" do
			it "With default parameters, " do
				Spigoter::CLI.main({:javaparm=>"-Xms1024M -Xmx4096M -jar spigot.jar", :compile=>false, :update=>false, :help=>false})
			end
		end
	end
end