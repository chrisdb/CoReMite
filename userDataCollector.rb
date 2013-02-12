require './rssTimeFeedReader'

class UserDataCollector

  @users

  def initialize
    props = YAML.load( open('./config.yaml') )
    @users = Array.new
    props['USERS'].each do |k, v|
      @users << { "name" => k, "mite_id" => v}
    end
  end

  def get_user_data
    @users.each do |user|
      rtf = RssTimeFeedReader.new(user["name"], user["mite_id"])
      user.merge!( {"values" => rtf.get_time_entries_per_day} )
      user.merge!( {"extended_values" => rtf.get_extended_time_entries_per_day} )
    end
    @users
  end

end