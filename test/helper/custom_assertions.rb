module CustomAssertions

  def self.arrays_content_equal(a, b)
    return false if a.length != b.length
    ah = Hash.new {|h,k| h[k] = 0 }
    a.each {|x| ah[x] += 1 }
    b.each {|x| ah[x] -= 1 }
    not ah.values.detect {|v| v != 0 }
  end

  def assert_arrays_equal(a, b, msg = nil)
    full_message = build_message(msg, "?\nshould contain same elements as\n?.", a, b)
    assert(CustomAssertions.arrays_content_equal(a, b), full_message)
  end

end