require './lib/coremite/rss_feed_reader'

class User

  attr_reader :name, :mite_id

  @times

  def initialize(name, mite_id, feed_reader)
    @name = name
    @mite_id = mite_id

    @times = feed_reader.read_times_for_mite_id(@mite_id)
  end

  def total_hours_for_day(day)
    @times[day] ? @times[day].map {|d| d[:time] }.inject{|sum,x| sum + x } : 0
  end

  def project_hours_for_day(day)
    @times[day] ? accumulated_times_for_day_grouped_by(day, [:project], [:activity, :comment]) : nil
  end

  def project_and_activity_hours_for_day(day)
    @times[day] ? accumulated_times_for_day_grouped_by(day, [:project, :activity], [:comment]) : nil
  end

  def detailed_hours_for_day(day)
    @times[day]
  end

  def max_project_length
    max_length_for_key(:project)
  end

  def max_activity_length
    max_length_for_key(:activity)
  end

private

  def accumulated_times_for_day_grouped_by(day, group_keys, to_be_removed_keys = [])
    times_copy = Marshal.load( Marshal.dump(@times[day]) )
    times_copy.clone.group_by {|hash| group_key = group_keys.map {|k| hash[k]} }.map do |group_key, hashes|
      delete_from_hashes(to_be_removed_keys, hashes)
      accumulate_times(hashes)
    end
  end

  def delete_from_hashes(keys, hashes)
    keys.each {|key| hashes.each {|hash| hash.delete(key)}}
  end

  def accumulate_times(hashes)
    hashes.reduce {|a, b| a.merge(b) {|key, v1, v2| key == :time ? v1 + v2 : v1 } }
  end

  def max_length_for_key(k)
    @times.map {|p| p[1].map {|o| o[k].length}}.flatten(1).max
  end
end