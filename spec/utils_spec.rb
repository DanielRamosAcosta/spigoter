require "spec_helper"
require "fileutils"

describe Spigoter::Utils do
    describe "#download" do
        it "It downloads the file correctly" do
            file = Spigoter::Utils.download('http://example.com')
            expect(file.size).to be_within(100).of(1270)
        end
        it "If there is no internet, then raise an error" do
            allow(Spigoter::Utils).to receive(:open).and_raise(SocketError)
            expect{Spigoter::Utils.download('http://example.com')}.to raise_error(RuntimeError, "Can't download anything from http://example.com, check internet?")
        end
    end
    describe "#which" do
        it "If that program exists, then true" do
            expect(Spigoter::Utils.which('cat')).to eq '/bin/cat'
        end
        it "In other case, false" do
            expect(Spigoter::Utils.which('catasdasd')).to be nil
        end
    end
end
