require 'open-uri'
require 'logging'

module Spigoter
  # Class that represent a devBukkit plugin.
  # @author Daniel Ramos Acosta <danielramosacosta@hotmail.com>
  class PluginBukkit < Plugin
    def initialize(website)
      raise "Bad URL #{website}" if website.match(%r{http://dev.bukkit.org/bukkit-plugins/[a-z\-]+/?}).nil?
      super(website)
    end

    def download_page
      return @download_page unless @download_page.nil?
      matches = @main_page.match(/"user-action user-action-download">\s+<a href="(?<download_page_url>.+)">Download/)
      url_download_page = matches[:download_page_url]
      @download_page = open("http://dev.bukkit.org/#{url_download_page}").read
    end

    def download_url
      return @download_url unless @download_url.nil?
      download_page
      @download_url = /href="(?<download_url>.+)">Download/.match(@download_page)[:download_url]
    end

    def version
      return @version unless @version.nil?
      download_page
      @version = %r{3">\s*<h1>\s+(?<version>.+)\s+</h1>}.match(@download_page)[:version]
    end

    def name
      return @name unless @name.nil?
      @name = %r{</div>\s*<h1>\s*(?<name>.+)\s*</h1>\s*</header>}.match(@main_page)[:name]
    end
  end
end
