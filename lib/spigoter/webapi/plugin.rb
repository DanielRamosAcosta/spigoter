require 'open-uri'
require 'logging'

module Spigoter
	class Plugin
		def initialize(website)
			@url = website # Url of the plugin
			@main_page     # Mainpage content
			@name          # Name of the plugin
			@download_page # Content of the download page
			@download_url  # Download url of the plugin
			@regexp        # Regexp that matches the URL
		end
		def main_page
			return @main_page unless @main_page.nil?
			begin
				@main_page = open(@url).read
			rescue
				raise "404 Error, that plugin URL doesn't exists"
			end
			return @main_page
		end
		def download
			download_url
			begin
				file = open(@download_url).read
			rescue
				raise "Can't download file for #{name}, #{@download_url}, check internet?"
			end
			return file
		end
	end
end