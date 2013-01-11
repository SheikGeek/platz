require 'test_helper'
require 'google_poll'

class GooglePollTest < ActiveSupport::TestCase
  GOOGLE_RESPONSE = File.read(Rails.root.join("test/fixtures/google_calendar_response.atom"))
  test "polling data from google calendar" do
    stub_request(:any, "https://www.google.com/calendar/feeds//private-/basic").to_return(:body => GOOGLE_RESPONSE)
    assert_difference "Event.count", 1 do
      GooglePoll.work
    end
    event = Event.last
    assert_equal "YWlqYmhwb3Qyczc1YWhkdXBsamQ3Z3NnNm8gY2MxM3NxdWFyZXRlc3RAbQ", event.google_event_id
  end
end
