require 'test_helper'

class GooglePollTest < ActiveSupport::TestCase
  test "the truth" do
    #stub stuff
    assert_difference "Event.count", 1 do
      GooglePoll.work
    end
  end
end
