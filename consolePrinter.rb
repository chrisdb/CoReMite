require 'date'

class ConsolePrinter

  attr_accessor :users, :days

  @@CHARS_PER_USER = 12
  @@PADDING = 2
  @preserved_space
  @variable_line_length

  @@DETAILED_DAYS = 5
  @@DETAILED_LINE_LENGTH = 60
  @@DETAILED_LINE_CENTER = @@DETAILED_LINE_LENGTH - 22

  def initialize(u, d)
    @users = u
    @days = d

    @preserved_space = @@CHARS_PER_USER + (2 * @@PADDING)
    @variable_line_length = (@preserved_space + 1) * @users.size
  end

  def print_separator_with_char(length=nil, separator="=")
    if (length)
      1.upto(length).each {|i| print separator}
      print "\n"
    else
      1.upto((@preserved_space + 1) * users.size + @@CHARS_PER_USER).each {|i| print separator}
      print "\n"
    end
  end

  def print_separator(length=nil)
    print_separator_with_char(length)
  end

  def print_thin_separator(length=nil)
    print_separator_with_char(length, '-')
  end

  def print_column_names
    print "*** Date **|"
    users.each do |user|
      print " #{user['name']} ".center(@preserved_space, "*")
      print "|"
    end
    print "\n"
  end

  def print_data_columns
    days.each do |day|
      print "#{day.to_s} |"
      users.each do |user|
        print user['values'][day].to_s.center(@preserved_space, " ")
        print "|"
      end
      print "\n"
      if (day.wday % 7 == 1)
        print_thin_separator
      end
    end
  end

  def print_times
    puts "\n" + " Times tracked in mite by day ".center(@variable_line_length + @@CHARS_PER_USER, "=")
    print_separator
    print_column_names
    print_separator
    print_data_columns
    puts " The End ".center(@variable_line_length + @@CHARS_PER_USER, "=")
    print_separator
    print "\n"
  end

  def print_time_entry(day, entry, first)
    print first ? "#{day.to_s} |" : "           |"
    print " " + entry[1].center(@@DETAILED_LINE_CENTER, " ") + " | " + entry[0].to_s.center(4, " ") + " |\n"
  end

  def print_daily_times_for_user(user)
    puts "\n" + " Detailed time for user #{user['name']} ".center(@@DETAILED_LINE_LENGTH, "=")
    print_separator(@@DETAILED_LINE_LENGTH)
    0.upto(@@DETAILED_DAYS - 1) do |i|
      day = days[i]
      if user['extended_values'][day] && user['extended_values'][day].length > 0
        user['extended_values'][day].each_with_index do |entry, i|
          print_time_entry(day, entry, i == 0)
        end
        print_thin_separator(@@DETAILED_LINE_LENGTH)
        puts "   Total   | " + " ".to_s.center(@@DETAILED_LINE_CENTER, " ") + " | " + user['values'][day].to_s.center(4, " ") + " |"
      else
        puts "#{day.to_s} |" + " - / -".center(40, " ") + "| -:-- |"
      end
      print_separator(@@DETAILED_LINE_LENGTH)
    end
    puts ""
  end

  def print_extended_times
    users.each do |user|
      print_daily_times_for_user user
    end
  end
end