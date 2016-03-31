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

			raise "Bad URL #{@url}" if @url.match(/^http:\/\/mods.curse.com\/bukkit-plugins\/minecraft\/[a-z\-]+$/).nil?

			@log = Logging.logger['Spigoter::PluginCurse']
  			@log.add_appenders 'stdout'
  			@log.level = :info
		end
		def main_page
			return @main_page unless @main_page.nil?
			@log.info "Downloading main page"
			begin
				@main_page = open(@url).read
			rescue
				raise "404 Error, that plugin URL doesn't exists"
			end
			return @main_page unless @main_page.nil?
			raise "Mainpage url error"
		end
		def download_page
			return @download_page unless @download_page.nil?
			@log.info "Downloading download page"
			begin
				@download_page = open(@url+'/download').read
			rescue
				raise "404 Error, that plugin URL doesn't exists"
			end
			return @download_page unless @download_page.nil?
			raise "Download page url error"
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
			file = open(@download_url).read
			return file unless file.nil?
			raise "Can't download file for #{name}, #{@download_url}"
		end
	end
end