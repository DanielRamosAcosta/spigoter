require 'spec_helper'
require 'fileutils'

describe Spigoter::Server do
	before :all do
		@server_settings = {name: "testserver"}
	end
	it ' creates de the server directory' do
		Spigoter::Server.new(@server_settings)
	end
	it 'downloads spigot buildtools successfully' do
	end
	after :all do
		FileUtils.rm_r @server_settings[:name]
	end
end
