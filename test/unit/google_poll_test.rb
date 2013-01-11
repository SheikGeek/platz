require 'test_helper'
require 'google_poll'

class GooglePollTest < ActiveSupport::TestCase
  GOOGLE_RESPONSE = File.read(Rails.root.join("test/fixtures/google_calendar_response.atom"))
  test "imports data from google calendar" do
    stub_request(:any, "https://www.google.com/calendar/feeds//private-/basic").to_return(:body => GOOGLE_RESPONSE)
    assert_difference "Event.count", 1 do
      GooglePoll.import
    end
    event = Event.last
    assert_equal "YWlqYmhwb3Qyczc1YWhkdXBsamQ3Z3NnNm8gY2MxM3NxdWFyZXRlc3RAbQ", event.google_event_id
  end

  test "doesn't duplicate data from google calendar" do
    Event.create!(:google_event_id => "YWlqYmhwb3Qyczc1YWhkdXBsamQ3Z3NnNm8gY2MxM3NxdWFyZXRlc3RAbQ")
    stub_request(:any, "https://www.google.com/calendar/feeds//private-/basic").to_return(:body => GOOGLE_RESPONSE)
    assert_no_difference "Event.count" do
      GooglePoll.import
    end
  end
end
