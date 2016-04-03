require 'open-uri'
require 'logging'

module Spigoter
    class PluginBukkit < Plugin
        def initialize(website)
            super(website)

            raise "Bad URL #{@url}" if @url.match(/http:\/\/dev.bukkit.org\/bukkit-plugins\/[a-z\-]+\/?/).nil?
        end
        def download_page
            return @download_page unless @download_page.nil?
            main_page
            url_download_page = @main_page.match(/<a href="(?<download_page_url>.+)">Download/)[:download_page_url]
            @download_page = open("http://dev.bukkit.org/#{url_download_page}").read
            # Don't need to begin-rescue, it's done by main_page
        end
        def download_url
            return @download_url unless @download_url.nil?
            download_page
            @download_url = /href="(?<download_url>.+)">Download/.match(@download_page)[:download_url]
        end
        def version
            return @version unless @version.nil?
            download_page
            @version = /3">\s*<h1>\s+(?<version>.+)\s+<\/h1>/.match(@download_page)[:version]
        end
        def name
            return @name unless @name.nil?
            @name = /ins\/(?<name>[a-z\-]+)\/?/.match(@url)[:name]
        end
    end
end
