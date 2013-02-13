require './rssTimeFeedReader'

class UserDataCollector

  @users
  @props

  def initialize(props)
    @props = props
    @users = Array.new
    props['USERS'].each do |k, v|
      @users << { "name" => k, "mite_id" => v}
    end
  end

  def get_user_data
    @users.each do |user|
      rtf = RssTimeFeedReader.new(user["name"], user["mite_id"], @props)
      user.merge!( {"daily_values" => rtf.get_time_entries_per_day} )
      user.merge!( {"daily_activity_values" => rtf.get_time_activity_entries_per_day} )
    end
    @users
  end

end