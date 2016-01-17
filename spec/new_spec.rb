require 'spec_helper'
require 'fileutils'

describe Spigoter::Server do
	before :all do
		Dir.chdir('tmp')
		@server_settings = {name: "testserver"}
		Spigoter::Server.new(@server_settings)
	end
	it 'raises expection upon not-named inicialization' do
		expect{Spigoter::Server.new({})}.to raise_error(ArgumentError)
	end
	it 'creates de the server directory' do
		expect(Dir.exists?(@server_settings[:name])).to be true
	end
	it 'creates the build directory' do
		expect(Dir.exists?("#{@server_settings[:name]}/build")).to be true
	end
	after :all do
		#FileUtils.rm_r @server_settings[:name]
	end
end
