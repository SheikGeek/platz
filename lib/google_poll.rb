require 'net/http'
require 'uri'

class GooglePoll
  MAGIC_COOKIE = ENV["GOOGLE_MAGIC_COOKIE"]
  USER_ID = ENV["GOOGLE_USER_ID"]

  def self.import
    atom_data = fetch_calendar(calendar_uri)
    event_entries = Nokogiri.XML(atom_data).css("feed entry")
    event_entries.each do |event_entry|
      uri = URI(event_entry.at("link[rel=alternate]")['href'])
      event_id = uri.query.split("&").map {|key_val| key_val.split("=") }.detect{|param, value| param == "eid"}.last
      Rails.logger.info("found event: #{event_id}")
      Event.find_or_create_by_google_event_id(event_id)
    end
  end

  def self.work
    while(true)
      begin
        import
      rescue  => ex
        Rails.logger.error("An exception occured in the worker: " + ex.message)
        Rails.logger.error("An exception occured in the worker: " + ex.backtrace)
      end
      sleep(10)
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
