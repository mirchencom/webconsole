#!/usr/bin/env ruby

require "test/unit"

require_relative "lib/window"
require_relative "lib/test_constants"

def time_diff_milli(start, finish)
   (finish - start) * 1000.0
end


# msecs = time_diff_milli t1, t2

class TestController < Test::Unit::TestCase

  TRIALS = 5
  def test_controller
    window = Window.new


    start = Time.now
    for i in 1..TRIALS
      window.load_html_1(TEST_HTML_1)
      window.load_html_1(TEST_HTML_2)
    end
    finish = Time.now
    puts "Method 1 = #{finish - start}"

    start = Time.now
    for i in 1..TRIALS
      window.load_html_2(TEST_HTML_1)
      window.load_html_2(TEST_HTML_2)
    end
    finish = Time.now
    puts "Method 2 = #{finish - start}"




    window.close
  end

end
