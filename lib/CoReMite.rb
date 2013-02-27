require './lib/coremite/console_printer'
require './lib/coremite/user'
require './lib/coremite/rss_feed_reader'
require 'date'
require 'yaml'

class CoReMite

  @@DEFAULT_CONFIG_PATH = './config.yaml'
  @@DEFAULT_NUMBER_OF_DAYS = 6

  def initialize(args = nil)
    config = args || @@DEFAULT_CONFIG_PATH
    props  = YAML.load( open(config) )

    number_of_days              = props['BUSINESS_DAYS_TO_TRACK']                || @@DEFAULT_NUMBER_OF_DAYS
    grouped_by_day              = props['SHOW_GROUPED_BY_DAY'].nil?              ? true  : props['SHOW_GROUPED_BY_DAY']
    grouped_by_day_and_activity = props['SHOW_GROUPED_BY_DAY_AND_ACTIVITY'].nil? ? false : props['SHOW_GROUPED_BY_DAY_AND_ACTIVITY']
    full_report                 = props['SHOW_FULL_REPORT'].nil?                 ? false : props['SHOW_FULL_REPORT']

    days = get_last_business_days(Date.today, number_of_days)

    rfr = RssFeedReader.new(props["MITE_KEY"], props["MITE_ACCOUNT"])
    users = Array.new
    props['USERS'].each {|name, mite_id| users << User.new(name, mite_id, rfr) }

    cp = ConsolePrinter.new(users, days, props["TRUNCATE_COMMENTS_LENGTH"])
    cp.print_daily_times          if grouped_by_day
    cp.print_daily_activity_times if grouped_by_day_and_activity
    cp.print_full_reports         if full_report
  end

private

  def get_last_business_days(start_date, number_of_days)
    result = Array.new
    result << start_date
    i = 1
    while result.size < number_of_days do
      if ((start_date - i).wday % 7 != 0) and ((start_date - i).wday % 7 != 6)
        result << (start_date - i)
      end
      i += 1
    end
    result
  end

end

CoReMite.new(ARGV[0])