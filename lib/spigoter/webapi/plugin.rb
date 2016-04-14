require 'open-uri'
require 'logging'

module Spigoter
  # Generalized plugin.
  # @author Daniel Ramos Acosta <danielramosacosta@hotmail.com>
  class Plugin
    def initialize(website)
      @url = website # Url of the plugin
      # @main_page     # Mainpage content
      # @name          # Name of the plugin
      # @download_page # Content of the download page
      # @download_url  # Download url of the plugin
      # @regexp        # Regexp that matches the URL
      # @file          # Where the file is stored
      main_page # preload main_page
    end

    def main_page
      return @main_page unless @main_page.nil?
      @main_page = Spigoter::Utils.download(@url)
    end

    def download_url
      @url # Dummy method, just to test
    end

    def file
      return @file unless @file.nil?
      @file = Spigoter::Utils.download(download_url) # download_url is implemented in child class
    end

    def self.list
      {
        curse: Spigoter::PluginCurse,
        devbukkit: Spigoter::PluginBukkit
      }
    end
  end
end
