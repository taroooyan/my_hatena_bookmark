class FavoentryController < ApplicationController
  require 'rss'
  require 'open-uri'
  require 'date'
  def show
    @entries = get_entry()
  end

  def get_entry
    url = 'http://b.hatena.ne.jp/taroooyan/favorite.rss'
    # rss server will check UserAgent. So we need to camouflage UserAgent
    opt = {}
    opt['User-Agent'] = 'Opera/9.80 (Windows NT 5.1)'
    open(url, opt) do |res|
      rss  = RSS::Parser.parse(res)
      entries = Array.new
      rss.items.each do |item|
        entry = Hash.new
        entry["title"] = item.title
        entry["link"]  = item.link
        entry["creator"] = item.dc_creator
        entry["date"]    = item.dc_date.strftime("%Y-%m-%d %H:%M:%S")
        entry["tag"]     = item.dc_subject
        # This code is bad. There is a better way than it.
        entry["head_text"] = item.content_encoded.match(/<p>([^<]+?)<\/p>/).to_s.delete("</p>").delete("<p>")
        entries << entry
      end
      return entries
    end
  end
end
