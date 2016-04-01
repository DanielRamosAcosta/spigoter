require 'open-uri'
require 'logging'

module Spigoter
	class PluginBukkit
		def initialize(website)
			@url = website # Url of the plugin
			@main_page     # Mainpage content
			@name          # Name of the plugin
			@download_page # Content of the download page
			@download_url  # Download url of the plugin

			raise "Bad URL #{@url}" if @url.match(/http:\/\/dev.bukkit.org\/bukkit-plugins\/[a-z\-]+\/?/).nil?
		end
		def main_page
			return @main_page unless @main_page.nil?
			Log.info "Downloading main page"
			begin
				@main_page = open(@url).read
			rescue
				raise "404 Error, that plugin URL doesn't exists"
			end
			return @main_page
		end
		def download_page
			return @download_page unless @download_page.nil?
			main_page
			Log.info "Downloading download page"
			url_download_page = @main_page.match(/<a href="(?<download_page_url>.+)">Download/)[:download_page_url]
			begin
				@download_page = open("http://dev.bukkit.org/#{url_download_page}").read
			rescue
				raise "404 Error, that plugin URL doesn't exists"
			end
			return @download_page
		end
		def download_url
			return @download_url unless @download_url.nil?
			download_page
			Log.info "Parsing download url"
			@download_url = /href="(?<download_url>.+)">Download/.match(@download_page)[:download_url]
		end
		def version
			return @version unless @version.nil?
			download_page
			Log.info "Getting version"
			@version = /3">\s*<h1>\s+(?<version>.+)\s+<\/h1>/.match(@download_page)[:version]
		end
		def name
			return @name unless @name.nil?
			Log.info "Getting name"
			@name = /ins\/(?<name>[a-z\-]+)\/?/.match(@url)[:name]
		end
		def download
			download_url
			Log.info "Downloading"
			begin
				file = open(@download_url).read
			rescue
				raise "Can't download file for #{name}, #{@download_url}, check internet?"
			end
			return file
		end
	end
end