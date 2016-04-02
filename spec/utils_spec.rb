require "spec_helper"
require "fileutils"

class DummyClass
end

describe Spigoter::Utils do
	before :each do
		@dummy_class = DummyClass.new
		@dummy_class.extend(Spigoter::Utils)
	end
	describe "#download" do
		it "It downloads the file correctly" do
			file = @dummy_class.download('http://example.com')
			expect(file.size).to be_within(100).of(1270)
		end
		it "If there is no internet, then raise an error" do
			allow(@dummy_class).to receive(:open).and_raise(SocketError)
			expect{@dummy_class.download('http://example.com')}.to raise_error(RuntimeError, "Can't download anything from http://example.com, check internet?")
		end
	end
end