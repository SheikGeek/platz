require 'net/http'
require 'uri'

class GooglePoll
  MAGIC_COOKIE = ENV["GOOGLE_MAGIC_COOKIE"]
  USER_ID = ENV["GOOGLE_USER_ID"]

  def self.work
    atom_data = fetch_calendar(calendar_uri)
    event_entries = Nokogiri.XML(atom_data).css("feed entry")
    event_entries.each do |event_entry|
      uri = URI(event_entry.at("link[rel=alternate]")['href'])
      event_id = uri.query.split("&").map {|key_val| key_val.split("=") }.detect{|param, value| param == "eid"}.last
      Event.create!(:google_event_id => event_id)
    end
  end

  protected

  def self.fetch_calendar(uri)
    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true
    http.verify_mode = OpenSSL::SSL::VERIFY_NONE
    request = Net::HTTP::Get.new(uri.request_uri)
    response = http.request(request)
    response.body
  end
  def self.calendar_uri
    URI("https://www.google.com/calendar/feeds/#{USER_ID}/private-#{MAGIC_COOKIE}/basic")
  end
end
