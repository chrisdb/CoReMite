class RssFeedReaderMock

  @mite_key
  @mite_account

  def read_times_for_mite_id(mite_id)
    {
      Date.parse("2013-02-22") => [
          {:project => "MyTestProject",  :activity => "Software Development", :comment => "fixing tests",               :time => 3.0},
          {:project => "MyTestProject",  :activity => "Deployment",           :comment => "Deployment of component A",  :time => 1.0},
          {:project => "MyOtherProject", :activity => "Software Development", :comment => "Implemented feature FooBar", :time => 4.0}
        ],
      Date.parse("2013-02-21") => [
          {:project => "MyTestProject",  :activity => "Software Development", :comment => "Refactoring Login",              :time => 6.0},
          {:project => "Daily Business", :activity => "IT Support",           :comment => "Support for Account Management", :time => 1.25},
          {:project => "MyTestProject",  :activity => "Meetings",             :comment => "Project roadmap",                :time => 1.5}
        ],
      Date.parse("2013-02-20") => [
          {:project => "MyTestProject", :activity => "Software Development", :comment => "Code review of feature 1234", :time => 1.00},
          {:project => "MyTestProject", :activity => "Software Development", :comment => "Feature 789",                 :time => 3.00},
          {:project => "MyTestProject", :activity => "Software Development", :comment => "Feature 456",                 :time => 4.00}
        ],
      Date.parse("2013-02-19") => [
          {:project => "MyTestProject",  :activity => "Software Development",  :comment => "Refactoring Feature A",          :time => 2.0},
          {:project => "Daily Business", :activity => "IT Support",            :comment => "Support for Account Management", :time => 1.25},
          {:project => "MyTestProject",  :activity => "Software Development",  :comment => "Code Review Feature A",          :time => 1.5},
          {:project => "MyTestProject",  :activity => "Meetings",              :comment => "Retrospective",                  :time => 1.5},
          {:project => "MyOtherProject", :activity => "Software Development",  :comment => "Implemented feature FooBar",     :time => 3.0}
        ]
    }
  end

end