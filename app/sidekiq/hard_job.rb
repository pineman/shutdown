require 'net/http'
require 'uri'
require 'async'

class HardJob
  include Sidekiq::Job

  def perform
    resp1, resp2 = Async do
      [Async { req }, Async { req }].map(&:wait)
    end.wait
    puts "tasks returned nil!" if resp1.nil? && resp2.nil?
  end

  def req
    uri = URI("https://httpbin.org/delay/10")
    Net::HTTP.start(uri.host, uri.port, use_ssl: true) do |http|
      http.request(Net::HTTP::Get.new(uri))
    end
  end
end
