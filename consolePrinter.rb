require 'date'

class ConsolePrinter

  attr_accessor :users, :days

  @@PADDING = 2
  @@DATE_ROW_LENGTH = 12
  @@TIME_ROW_LENGTH = 8
  @CHARS_PER_USER
  @preserved_space
  @variable_line_length
  @TRUNCATE_COMMENTS_LENGTH

  def initialize(u, d, props)
    @users = u
    @days = d

    @CHARS_PER_USER = @users.map { |p| p['name'].length }.max

    @TRUNCATE_COMMENTS_LENGTH = props['TRUNCATE_COMMENTS_LENGTH'] || 30

    @preserved_space = @CHARS_PER_USER + (2 * @@PADDING)
    @variable_line_length = ((@preserved_space + 1) * @users.size)
  end

  def print_separator_with_char(length=nil, separator="=")
    if (length)
      1.upto(length).each {|i| print separator}
      print "\n"
    else
      1.upto(@variable_line_length + @@DATE_ROW_LENGTH).each {|i| print separator}
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
        print user['daily_values'][day].to_s.center(@preserved_space, " ")
        print "|"
      end
      print "\n"
      if (day.wday % 7 == 1)
        print_thin_separator
      end
    end
  end

  def print_daily_times
    puts "\n" + " Times tracked in mite by day ".center(@variable_line_length + @@DATE_ROW_LENGTH, "=")
    print_separator
    print_column_names
    print_separator
    print_data_columns
    puts " The End ".center(@variable_line_length + @@DATE_ROW_LENGTH, "=")
    print_separator
    print "\n"
  end

  def print_time_entry(day, entry, first, length)
    print first ? "#{day.to_s} |" : "           |"
    print entry[1].center(length, " ") + "| " + entry[0].to_s.center(4, " ") + " |\n"
  end

  def print_daily_times_for_user(user)
    line_center_length = user['daily_activity_values'].map {|p| p[1].map {|o| o[1]} }.flatten(1).map {|s| s.length}.max + (2 * @@PADDING)
    line_length = @@DATE_ROW_LENGTH + @@TIME_ROW_LENGTH + line_center_length

    puts "\n" + " Detailed time for user #{user['name']} ".center(line_length, "=")
    print_separator(line_length)
    days.each do |day|
      if user['daily_activity_values'][day] && user['daily_activity_values'][day].length > 0
        user['daily_activity_values'][day].each_with_index do |entry, i|
          print_time_entry(day, entry, i == 0, line_center_length)
        end
        print_thin_separator(line_length)
        puts "   Total   |" + " ".to_s.center(line_center_length, " ") + "| " + user['daily_values'][day].to_s.center(4, " ") + " |"
      else
        puts "#{day.to_s} |" + "- / -".center(line_center_length, " ") + "| -:-- |"
      end
      print_separator(line_length)
    end
    puts ""
  end

  def print_daily_activity_times
    users.each do |user|
      print_daily_times_for_user user
    end
  end

  def truncate(str, length)
    str.length <= length ? str : str.slice(0, length-3) + '...'
  end

  def print_full_entry(day, entry, first, project_length, activity_length, comment_length)
    print first ? "#{day.to_s} |" : "           |"
    print entry[:project].center(project_length, " ") + "|" + 
          entry[:activity].center(activity_length, " ") + "|" + 
          truncate(entry[:comment], @TRUNCATE_COMMENTS_LENGTH).center(comment_length, " ") + "| " + 
          entry[:time].to_s.center(4, " ") + " |\n"
  end

  def print_full_report_for_user(user)
    project_length = user['full_report'].map {|p| p[1].map {|q| q[:project].length}}.flatten(1).max + (2 * @@PADDING)
    activity_length = user['full_report'].map {|p| p[1].map {|q| q[:activity].length}}.flatten(1).max + (2 * @@PADDING)
    comment_length = @TRUNCATE_COMMENTS_LENGTH + (2 * @@PADDING)
    variable_length = project_length + activity_length + comment_length + 2

    line_length = @@DATE_ROW_LENGTH + @@TIME_ROW_LENGTH + variable_length

    puts "\n" + " Full report for user #{user['name']} ".center(line_length, "=")
    print_thin_separator(line_length)
    puts "    Date   |" + "Project".center(project_length, " ") + "|" + "Activity".center(activity_length, " ") + "|" + "Comment".center(comment_length, " ") + "| Time |"
    print_separator(line_length)
    days.each do |day|
      if user['full_report'][day] && user['full_report'][day].length > 0
        user['full_report'][day].each_with_index do |entry, i|
          print_full_entry(day, entry, i == 0, project_length, activity_length, comment_length)
        end
        print_thin_separator(line_length)
        puts "   Total   |" + " ".to_s.center(variable_length, " ") + "| " + user['daily_values'][day].to_s.center(4, " ") + " |"
      else
        puts "#{day.to_s} |" + "- / -".center(variable_length, " ") + "| -:-- |"
      end
      print_separator(line_length)
    end
    puts ""
  end

  def print_full_reports
    users.each do |user|
      print_full_report_for_user user
    end
  end
end