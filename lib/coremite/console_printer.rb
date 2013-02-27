require 'date'

class ConsolePrinter

  @@DEFAULT_TRUNCATE_COMMENTS_LENGTH = 30

  @@PADDING = 2
  @@DATE_ROW_LENGTH = 12
  @@TIME_ROW_LENGTH = 8

  @chars_per_user
  @preserved_space
  @variable_line_length
  @truncate_comments_length
  @users
  @days

  def initialize(u, d, truncate_comments_length)
    @users = u
    @days = d
    @chars_per_user = @users.map {|p| p.name.length }.max
    @truncate_comments_length = truncate_comments_length || @@DEFAULT_TRUNCATE_COMMENTS_LENGTH
    @preserved_space = @chars_per_user + (2 * @@PADDING)
    @variable_line_length = ((@preserved_space + 1) * @users.size)
  end

  def print_daily_times
    puts "\n" + " Times tracked in mite by day ".center(@variable_line_length + @@DATE_ROW_LENGTH, "=")
    print_separator
    print_column_names_for_grouped_by_day
    print_separator
    print_data_columns_for_grouped_by_day
    puts " The End ".center(@variable_line_length + @@DATE_ROW_LENGTH, "=")
    print_separator
    print "\n"
  end

  def print_daily_activity_times
    @users.each {|user| print_activity_times_for_user user }
  end

  def print_full_reports
    @users.each {|user| print_full_report_for_user user }
  end

private

  def print_separator(length=nil)
    print_separator_with_char(length)
  end

  def print_thin_separator(length=nil)
    print_separator_with_char(length, '-')
  end

  def print_separator_with_char(length=nil, separator="=")
    length ? 1.upto(length).each {|i| print separator} : 1.upto(@variable_line_length + @@DATE_ROW_LENGTH).each {|i| print separator}
    print "\n"
  end


  def print_column_names_for_grouped_by_day
    print "*** Date **|"
    @users.each {|user| print " #{user.name} ".center(@preserved_space, "*"); print "|" }
    print "\n"
  end

  def print_data_columns_for_grouped_by_day
    @days.each do |day|
      print "#{day.to_s} |"
      @users.each {|user| print ("%.02f" % user.total_hours_for_day(day)).center(@preserved_space, " "); print "|" }
      print "\n"
      print_thin_separator if (day.wday % 7 == 1)
    end
  end


  def print_activity_times_for_user(user)
    line_center_length = user.max_activity_length + (2 * @@PADDING)
    line_length = @@DATE_ROW_LENGTH + @@TIME_ROW_LENGTH + line_center_length

    puts "\n" + " Detailed time for user #{user.name} ".center(line_length, "=")
    print_separator(line_length)
    @days.each do |day|
      values = user.project_and_activity_hours_for_day(day)
      if values && values.length > 0
        values.each_with_index {|entry, i| print_activity_time_entry(day, entry, i == 0, line_center_length) }
        print_thin_separator(line_length)
        puts "   Total   |" + " ".to_s.center(line_center_length, " ") + "| " + ("%.02f" % user.total_hours_for_day(day)).center(4, " ") + " |" #TODO
      else
        puts "#{day.to_s} |" + "- / -".center(line_center_length, " ") + "| -:-- |"
      end
      print_separator(line_length)
    end
    puts ""
  end

  def print_activity_time_entry(day, entry, first, length)
    print first ? "#{day.to_s} |" : "           |"
    print entry[:activity].center(length, " ") + "| " + ("%.02f" % entry[:time]).center(4, " ") + " |\n"
  end


  def print_full_report_for_user(user)
    project_length = user.max_project_length + (2 * @@PADDING)
    activity_length = user.max_activity_length + (2 * @@PADDING)
    comment_length = @truncate_comments_length + (2 * @@PADDING)
    variable_length = project_length + activity_length + comment_length + 2
    line_length = @@DATE_ROW_LENGTH + @@TIME_ROW_LENGTH + variable_length

    puts "\n" + " Full report for user #{user.name} ".center(line_length, "=")
    print_thin_separator(line_length)
    puts "    Date   |" + "Project".center(project_length, " ") + "|" + "Activity".center(activity_length, " ") + "|" + "Comment".center(comment_length, " ") + "| Time |"
    print_separator(line_length)
    @days.each do |day|
      values = user.detailed_hours_for_day(day)
      if values && values.length > 0
        values.each_with_index {|entry, i| print_full_entry(day, entry, i == 0, project_length, activity_length, comment_length) }
        print_thin_separator(line_length)
        puts "   Total   |" + " ".to_s.center(variable_length, " ") + "| " + ("%.02f" % user.total_hours_for_day(day)).center(4, " ") + " |"
      else
        puts "#{day.to_s} |" + "- / -".center(variable_length, " ") + "| -:-- |"
      end
      print_separator(line_length)
    end
    puts ""
  end

  def print_full_entry(day, entry, first, project_length, activity_length, comment_length)
    print first ? "#{day.to_s} |" : "           |"
    print entry[:project].center(project_length, " ") + "|" +
          entry[:activity].center(activity_length, " ") + "|" +
          truncate(entry[:comment], @truncate_comments_length).center(comment_length, " ") + "| " +
          ("%.02f" % entry[:time]).center(4, " ") + " |\n"
  end

  def truncate(str, length)
    str ? str.length <= length ? str : str.slice(0, length-3) + "..." : ""
  end

end