require 'open-uri'
require 'logging'

module Spigoter
  # Class that represent a Curse plugin.
  # @author Daniel Ramos Acosta <danielramosacosta@hotmail.com>
  class PluginCurse < Plugin
    def initialize(website)
      raise "Bad URL #{website}" if website.match(%r{^http://mods.curse.com/bukkit-plugins/minecraft/[a-z\-]+$}).nil?
      super(website)
    end

    def download_page
      return @download_page unless @download_page.nil?
      @download_page = Spigoter::Utils.download("#{@url}/download")
    end

    def download_url
      return @download_url unless @download_url.nil?
      download_page
      @download_url = %r{(?<download_url>http://addons\.curse\.cursecdn\.com.+\.jar)}
                      .match(@download_page)[:download_url]
    end

    def version
      return @version unless @version.nil?
      @version = /Newest File: (?<version>.+)</.match(@main_page)[:version]
    end

    def name
      return @name unless @name.nil?
      @name = Regexp.new('Main Title -->\s*<H2 >\s*(?<name>.+)</H2>').match(@main_page)[:name]
    end

    private :download_page, :download_url
  end
end
