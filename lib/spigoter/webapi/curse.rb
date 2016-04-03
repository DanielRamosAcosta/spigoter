require 'open-uri'
require 'logging'

module Spigoter
    class PluginCurse < Plugin
        def initialize(website)
            super(website)

            raise "Bad URL #{@url}" if @url.match(/^http:\/\/mods.curse.com\/bukkit-plugins\/minecraft\/[a-z\-]+$/).nil?
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
            main_page
            @version = /Newest File: (?<version>.+)</.match(@main_page)[:version]
        end
        def name
            return @name unless @name.nil?
            @name = /minecraft\/(?<name>.+)/.match(@url)[:name]
        end
    end
end
