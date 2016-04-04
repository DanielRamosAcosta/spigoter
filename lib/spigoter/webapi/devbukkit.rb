require 'open-uri'
require 'logging'

module Spigoter
    class PluginBukkit < Plugin
        def initialize(website)
            raise "Bad URL #{website}" if website.match(/http:\/\/dev.bukkit.org\/bukkit-plugins\/[a-z\-]+\/?/).nil?
            super(website)
        end
        def download_page
            return @download_page unless @download_page.nil?
            url_download_page = @main_page.match(/<a href="(?<download_page_url>.+)">Download/)[:download_page_url]
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
            @version = /3">\s*<h1>\s+(?<version>.+)\s+<\/h1>/.match(@download_page)[:version]
        end
        def name
            return @name unless @name.nil?
            @name = /<\/div>\s*<h1>\s*(?<name>.+)\s*<\/h1>\s*<\/header>/.match(@main_page)[:name]
        end
    end
end
