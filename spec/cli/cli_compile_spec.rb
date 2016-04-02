require 'spec_helper'

describe Spigoter::CLI do
	describe "#compile" do
		describe "When called with default parameters" do
			it "With default parameters, " do
				Spigoter::CLI.run('compile')
			end
		end
	end
end