require 'test/unit'
require './lib/coremite/user'
require './test/mocks/rss_feed_reader_mock'
require './test/helper/custom_assertions'

class TestFoobar < Test::Unit::TestCase

  include CustomAssertions

  @feed_reader_mock
  @user

  @@DATE_1 = Date.parse("2013-02-22")
  @@DATE_2 = Date.parse("2013-02-21")
  @@DATE_3 = Date.parse("2013-02-20")
  @@DATE_4 = Date.parse("2013-02-19")

  def setup
    @feed_reader_mock = RssFeedReaderMock.new
    @user = User.new("John Doe", 12345, @feed_reader_mock)
  end

  def test_basic_attributes
    assert_equal("John Doe", @user.name)
    assert_equal(12345, @user.mite_id)
  end

  def test_total_hours_for_day
    assert_equal( 8.0,  @user.total_hours_for_day(@@DATE_1))
    assert_equal( 8.75, @user.total_hours_for_day(@@DATE_2))
    assert_equal( 8.0,  @user.total_hours_for_day(@@DATE_3))
    assert_equal( 9.25, @user.total_hours_for_day(@@DATE_4))
  end

  def test_project_hours_for_day
    assert_equal([ {:project => "MyTestProject",  :time => 4.0},
                   {:project => "MyOtherProject", :time => 4.0} ],
                 @user.project_hours_for_day(@@DATE_1))

    assert_equal([ {:project => "MyTestProject",  :time => 7.5},
                   {:project => "Daily Business", :time => 1.25} ],
                 @user.project_hours_for_day(@@DATE_2))

    assert_equal([ {:project => "MyTestProject",  :time => 8.0} ],
                 @user.project_hours_for_day(@@DATE_3))

    assert_equal([ {:project => "MyTestProject",  :time => 5.0},
                   {:project => "Daily Business", :time => 1.25},
                   {:project => "MyOtherProject", :time => 3.0} ],
                 @user.project_hours_for_day(@@DATE_4))
  end

  def test_project_and_activity_hours_for_day
    assert_arrays_equal([ {:project => "MyTestProject",  :activity => "Software Development", :time => 3.0},
                          {:project => "MyTestProject",  :activity => "Deployment",           :time => 1.0},
                          {:project => "MyOtherProject", :activity => "Software Development", :time => 4.0} ],
                        @user.project_and_activity_hours_for_day(@@DATE_1))

    assert_arrays_equal([ {:project => "MyTestProject",  :activity => "Software Development", :time => 6.0},
                          {:project => "MyTestProject",  :activity => "Meetings",             :time => 1.5},
                          {:project => "Daily Business", :activity => "IT Support",           :time => 1.25} ],
                        @user.project_and_activity_hours_for_day(@@DATE_2))

    assert_arrays_equal([ {:project => "MyTestProject",  :activity => "Software Development", :time => 8.0} ],
                          @user.project_and_activity_hours_for_day(@@DATE_3))

    assert_arrays_equal([ {:project => "MyTestProject",  :activity => "Software Development", :time => 3.5},
                          {:project => "MyTestProject",  :activity => "Meetings",             :time => 1.5},
                          {:project => "Daily Business", :activity => "IT Support",           :time => 1.25},
                          {:project => "MyOtherProject", :activity => "Software Development", :time => 3.0} ],
                        @user.project_and_activity_hours_for_day(@@DATE_4))
  end

  def test_detailed_hours_for_day
    assert_arrays_equal([ {:project => "MyTestProject",  :activity => "Software Development", :comment => "fixing tests",               :time => 3.0},
                          {:project => "MyTestProject",  :activity => "Deployment",           :comment => "Deployment of component A",  :time => 1.0},
                          {:project => "MyOtherProject", :activity => "Software Development", :comment => "Implemented feature FooBar", :time => 4.0} ],
                        @user.detailed_hours_for_day(@@DATE_1))

    assert_arrays_equal([ {:project => "MyTestProject",  :activity => "Software Development", :comment => "Refactoring Login",              :time => 6.0},
                          {:project => "Daily Business", :activity => "IT Support",           :comment => "Support for Account Management", :time => 1.25},
                          {:project => "MyTestProject",  :activity => "Meetings",             :comment => "Project roadmap",                :time => 1.5} ],
                        @user.detailed_hours_for_day(@@DATE_2))

    assert_arrays_equal([ {:project => "MyTestProject", :activity => "Software Development", :comment => "Code review of feature 1234", :time => 1.00},
                          {:project => "MyTestProject", :activity => "Software Development", :comment => "Feature 789",                 :time => 3.00},
                          {:project => "MyTestProject", :activity => "Software Development", :comment => "Feature 456",                 :time => 4.00} ],
                        @user.detailed_hours_for_day(@@DATE_3))

    assert_arrays_equal([ {:project => "MyTestProject",  :activity => "Software Development",  :comment => "Refactoring Feature A",          :time => 2.0},
                          {:project => "Daily Business", :activity => "IT Support",            :comment => "Support for Account Management", :time => 1.25},
                          {:project => "MyTestProject",  :activity => "Software Development",  :comment => "Code Review Feature A",          :time => 1.5},
                          {:project => "MyTestProject",  :activity => "Meetings",              :comment => "Retrospective",                  :time => 1.5},
                          {:project => "MyOtherProject", :activity => "Software Development",  :comment => "Implemented feature FooBar",     :time => 3.0} ],
                        @user.detailed_hours_for_day(@@DATE_4))
  end

  def test_max_activity_length
    assert_equal(20, @user.max_activity_length)
  end

  def test_max_project_length
    assert_equal(14, @user.max_project_length)
  end

end