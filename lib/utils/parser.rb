#encoding: utf-8
require 'singleton'
require 'utils/cached_url'

module TimeControl
  module Utils
    class Parser
      include Singleton

      def initialize
        @cache = TimeControl::Utils::CachedUrl.instance
      end

      def parse_wiki_deputats(wiki_url)
        names = []
        begin
          Nokogiri::HTML(@cache.get(wiki_url, 'companies/moscow')).search(".//li/a").each do |a|
            if a.content =~ /,\s/ && a.content !~ /,\sInc/
              names.push a.content.gsub(',', '').gsub('ё', 'е').strip
            end
          end
        rescue OpenURI::HTTPError
        rescue Exception => e
          raise e
        end
        names
      end
    end
  end
end