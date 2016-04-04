require 'open-uri'
require 'logging'

module Spigoter
    class PluginCurse < Plugin
        def initialize(website)
            raise "Bad URL #{website}" if website.match(/^http:\/\/mods.curse.com\/bukkit-plugins\/minecraft\/[a-z\-]+$/).nil?
            super(website)
        end
        def download_page
            return @download_page unless @download_page.nil?
            begin
                @download_page = open(@url+'/download').read
            rescue
                raise "404 Error, that plugin URL doesn't exists"
            end
            return @download_page
        end
        def download_url
            return @download_url unless @download_url.nil?
            download_page
            @download_url = /(?<download_url>http:\/\/addons.curse.cursecdn.com.+\.jar)/.match(@download_page)[:download_url]
        end
        def version
            return @version unless @version.nil?
            @version = /Newest File: (?<version>.+)</.match(@main_page)[:version]
        end
        def name
            return @name unless @name.nil?
            @name = /Main Title -->\s*<H2 >\s*(?<name>.+)<\/H2>/.match(@main_page)[:name]
        end

        private :download_page, :download_url
    end
end
