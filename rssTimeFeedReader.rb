require 'rss'
require 'open-uri'
require 'yaml'
require 'htmlentities'

class RssTimeFeedReader
  attr_accessor :name, :mite_id

  @MITE_KEY
  @MITE_ACCOUNT

  @@PROJECT_REGEX = /.*Projekt:<\/strong>/
  @@ACTIVITY_REGEX = /.*Leistung:<\/strong>/
  @@COMMENT_REGEX = /.*Bemerkung:<\/strong>/
  @@TIME_REGEX = /.*Stunden:<\/strong>/
  @@CLOSING_REGEX = / <.*/

  def initialize( a, b, props )
    @MITE_KEY = props["MITE_KEY"]
    @MITE_ACCOUNT = props["MITE_ACCOUNT"]

    @name = a
    @mite_id = b
  end

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

  def get_time_entries_per_day_callback(item, result)
    d = item.pubDate.to_date
    t = (item.title.split(":")[0].to_f + (item.title.split(":")[1].to_f / 60)).round(2)
    {d => t}
  end

  def get_time_entries_per_day
    url = "https://#{@MITE_ACCOUNT}.mite.yo.lk/reports/time_entries.rss?key=#{@MITE_KEY}&user_id=#{mite_id}&group_by=day"
    get_time_entries(url, method(:get_time_entries_per_day_callback))
  end

  def get_time_activity_entries_per_day_callback(item, result)
    d = item.pubDate.to_date
    t = result[d] ? result[d] : []
    temp = item.description.gsub('[', '').gsub(']', '').gsub('"', '').split(', ')
    t << [ (temp[0].split(":")[0].to_f + (temp[0].split(":")[1].to_f / 60)).round(2), temp[1] ]
    {d => t}
  end

  def get_time_activity_entries_per_day
    url = "https://#{@MITE_ACCOUNT}.mite.yo.lk/reports/time_entries.rss?key=#{@MITE_KEY}&user_id=#{mite_id}&group_by=day%2Cservice"
    get_time_entries(url, method(:get_time_activity_entries_per_day_callback))
  end

  def parse_content(content, regx)
    HTMLEntities.new.decode(content.sub(regx, "").sub(@@CLOSING_REGEX, "")).gsub( /\r\n/m, "" ).strip!
  end

  def get_full_report_callback(item, result)
    d = item.pubDate.to_date
    t = result[d] ? result[d] : []

    content = item.content_encoded.gsub( /\r\n/m, "" )
    project = parse_content(content, @@PROJECT_REGEX)
    activity = parse_content(content, @@ACTIVITY_REGEX)
    comment = parse_content(content, @@COMMENT_REGEX)
    time = parse_content(content, @@TIME_REGEX)
    time = (time.split(":")[0].to_f + (time.split(":")[1].to_f / 60)).round(2)

    t << {:project => project, :activity => activity, :comment => comment, :time => time}
    {d => t}
  end

  def get_full_report
    url = "https://#{@MITE_ACCOUNT}.mite.yo.lk/reports/time_entries.rss?key=#{@MITE_KEY}&user_id=#{mite_id}"
    get_time_entries(url, method(:get_full_report_callback))
  end

end