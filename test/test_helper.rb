require 'test/unit'
require './test/helper/custom_assertions'

class TestHelper < Test::Unit::TestCase

  def test_arrays_equal_for_simple_arrays
    assert( CustomAssertions.arrays_content_equal( [1, 2, 3], [1, 2, 3]) )
    assert( CustomAssertions.arrays_content_equal( [1, 3, 2], [1, 2, 3]) )
    assert(!CustomAssertions.arrays_content_equal( [9, 8, 7], [1, 2, 3]) )
    assert(!CustomAssertions.arrays_content_equal( [1, 2],    [1, 2, 3]) )
  end

  def test_arrays_equal_for_two_dimensional_arrays
    assert( CustomAssertions.arrays_content_equal( [ [1, 2], [3, 4], [4, 5] ], [ [1, 2], [3, 4], [4, 5] ] ))
    assert( CustomAssertions.arrays_content_equal( [ [3, 4], [1, 2], [4, 5] ], [ [1, 2], [3, 4], [4, 5] ] ))
    assert(!CustomAssertions.arrays_content_equal( [ [1, 2], [3, 4]         ], [ [1, 2], [3, 4], [4, 5] ] ))
    assert(!CustomAssertions.arrays_content_equal( [ [7, 8], [9, 0], [4, 5] ], [ [1, 2], [3, 4], [4, 5] ]))
  end

  def test_arrays_equal_for_arrays_of_hashes
    assert( CustomAssertions.arrays_content_equal([ {:a => "foo",  :b => "bar"    },
                                                    {:a => 23,     :b => 42       },
                                                    {:a => "just", :b => "testing"} ],
                                                  [ {:a => "foo",  :b => "bar"    },
                                                    {:a => 23,     :b => 42       },
                                                    {:a => "just", :b => "testing"} ]))
    assert( CustomAssertions.arrays_content_equal([ {:a => 23,     :b => 42       },
                                                    {:a => "foo",  :b => "bar"    },
                                                    {:a => "just", :b => "testing"} ],
                                                  [ {:a => "foo",  :b => "bar"    },
                                                    {:a => 23,     :b => 42       },
                                                    {:a => "just", :b => "testing"} ]))
    assert(!CustomAssertions.arrays_content_equal([ {:a => 23,     :b => 42       },
                                                    {:a => "foo",  :b => "bar"    } ],
                                                  [ {:a => "foo",  :b => "bar"    },
                                                    {:a => 23,     :b => 42       },
                                                    {:a => "just", :b => "testing"} ]))
    assert(!CustomAssertions.arrays_content_equal([ {:a => 42,     :b => 23       },
                                                    {:a => "bar",  :b => "foo"    },
                                                    {:a => "just", :b => "testing"} ],
                                                  [ {:a => "foo",  :b => "bar"    },
                                                    {:a => 23,     :b => 42       },
                                                    {:a => "just", :b => "testing"} ]))
  end

end