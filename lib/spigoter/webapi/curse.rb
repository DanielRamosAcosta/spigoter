require 'open-uri'
require 'logging'

module Spigoter
	class PluginCurse
		def initialize(website)
			@url = website # Url of the plugin
			@main_page     # Mainpage content
			@name          # Name of the plugin
			@download_page # Content of the download page
			@download_url  # Download url of the plugin

			@log = Logging.logger['Spigoter::PluginCurse']
  			@log.add_appenders 'stdout'
  			@log.level = :info
		end
		def main_page
			return @main_page unless @main_page.nil?
			@log.info "Downloading main page"
			@main_page = open(@url).read
		end
		def download_page
			return @download_page unless @download_page.nil?
			@log.info "Downloading download page"
			@download_page = open(@url+'/download').read
		end
		def download_url
			return @download_url unless @download_url.nil?
			download_page
			@log.info "Parsing download url"
			@download_url = /(?<download_url>http:\/\/addons.curse.cursecdn.com.+\.jar)/.match(@download_page)[:download_url]
		end
		def version
			return @version unless @version.nil?
			main_page
			@log.info "Getting version"
			@version = /Newest File: (?<version>.+)</.match(@main_page)[:version]
		end
		def name
			return @name unless @name.nil?
			@log.info "Getting name"
			@name = /minecraft\/(?<name>.+)/.match(@url)[:name]
		end
		def download
			download_url
			@log.info "Downloading"
			open(@download_url) {|f| yield f }
		end
	end
end