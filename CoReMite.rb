require './userDataCollector'
require './consolePrinter'
require 'date'

config = ARGV[0] || './config.yaml'
props = YAML.load( open(config) )
number_of_days = props['BUSINESS_DAYS_TO_TRACK'] || 10
detailed = props['DETAILED'] || false

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
cp = ConsolePrinter.new(udc.get_user_data, days)
cp.print_times

if detailed
  cp.print_extended_times
end