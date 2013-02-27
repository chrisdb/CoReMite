require 'rss'
require 'open-uri'
require 'htmlentities'

class RssFeedReader

  @@PROJECT_REGEX = /.*Projekt:<\/strong>/
  @@ACTIVITY_REGEX = /.*Leistung:<\/strong>/
  @@COMMENT_REGEX = /.*Bemerkung:<\/strong>/
  @@TIME_REGEX = /.*Stunden:<\/strong>/
  @@CLOSING_REGEX = / <.*/

  @mite_key
  @mite_account

  def initialize(mite_key, mite_account)
    @mite_key = mite_key
    @mite_account = mite_account
  end

  def read_times_for_mite_id(mite_id)
    url = "https://#{@mite_account}.mite.yo.lk/reports/time_entries.rss?key=#{@mite_key}&user_id=#{mite_id}"
    get_time_entries(url, method(:process_time_entries))
  end

private

  def get_time_entries(url, callback)
    result = {}
    open(url) do |rss|
      feed = RSS::Parser.parse(rss)
      feed.items.each do |item|
        result.merge!(callback.call(item, result))
      end
    end
    result
  end

  def process_time_entries(item, result)
    d = item.pubDate.to_date
    t = result[d] ? result[d] : []

    content = item.content_encoded.gsub( /\r\n/m, "" )
    project = parse_content(content, @@PROJECT_REGEX)
    activity = parse_content(content, @@ACTIVITY_REGEX)
    comment = parse_content(content, @@COMMENT_REGEX)
    time = parse_content(content, @@TIME_REGEX)
    time = time.split(":")[0].to_f + (time.split(":")[1].to_f / 60)

    t << {:project => project, :activity => activity, :comment => comment, :time => time}
    {d => t}
  end

  def parse_content(content, regx)
    HTMLEntities.new.decode(content.sub(regx, "").sub(@@CLOSING_REGEX, "")).gsub( /\r\n/m, "" ).strip!
  end

end