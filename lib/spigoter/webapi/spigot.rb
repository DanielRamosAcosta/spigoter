require 'open-uri'
require 'logging'

module Spigoter
  # Class that represent a devBukkit plugin.
  # @author Daniel Ramos Acosta <danielramosacosta@hotmail.com>
  class PluginSpigot < Plugin
    def initialize(website)
      raise "Bad URL #{website}" if website.match(%r{https://www.spigotmc.org/resources/[a-z0-9\-]+/?}).nil?
      super(website)
    end

    def download_url
      return @download_url unless @download_url.nil?
      uri = /<a href="(?<download_url>resources.+)" class="inner">/.match(@main_page)[:download_url]
      @download_url = "https://www.spigotmc.org/#{uri}"
    end

    def version
      return @version unless @version.nil?
      @version = %r{class="muted">(?<version>.+)</span>}.match(@main_page)[:version]
    end

    def name
      return @name unless @name.nil?
      @name = /<h1>(?<name>.+?)\s*<span class="muted">/.match(@main_page)[:name]
    end
  end
end
