require './userDataCollector'
require './consolePrinter'
require 'date'

config = ARGV[0] || './config.yaml'
props = YAML.load( open(config) )
number_of_days = props['BUSINESS_DAYS_TO_TRACK'] || 10

grouped_by_day = props['SHOW_GROUPED_BY_DAY'].nil? ? true : props['SHOW_GROUPED_BY_DAY']
grouped_by_day_and_activity = props['SHOW_GROUPED_BY_DAY_AND_ACTIVITY'].nil? ? false : props['SHOW_GROUPED_BY_DAY_AND_ACTIVITY']
full_report = props['SHOW_FULL_REPORT'].nil? ? false : props['SHOW_FULL_REPORT']

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

days = get_last_business_days(Date.today, number_of_days)

udc = UserDataCollector.new(props)
cp = ConsolePrinter.new(udc.get_user_data, days, props)

if grouped_by_day
  cp.print_daily_times
end

if grouped_by_day_and_activity
  cp.print_daily_activity_times
end

if full_report
  cp.print_full_reports
end