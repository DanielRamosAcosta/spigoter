require 'open-uri'

module Spigoter
	class PluginCurse
		def initialize(website)
			@url = website # Url of the plugin
			@main_page     # Mainpage content
			@name          # Name of the plugin
			@download_page # Content of the download page
			@download_url  # Download url of the plugin
		end
		def main_page
			return @main_page unless @main_page.nil?
			@main_page = open(@url).read
		end
		def download_page
			return @download_page unless @download_page.nil?
			@download_page = open(@url+'/download').read
		end
		def download_url
			return @download_url unless @download_url.nil?
			download_page
			@download_url = /(?<download_url>http:\/\/addons.curse.cursecdn.com.+\.jar)/.match(@download_page)[:download_url]
		end
		def version
			return @version unless @version.nil?
			main_page
			@version = /Newest File: (?<version>.+)</.match(@main_page)[:version]
		end
		def name
			return @name unless @name.nil?
			@name = /minecraft\/(?<name>.+)/.match(@url)[:name]
		end
		def download
			download_url
			open(@download_url) {|f| yield f }
		end
	end
end