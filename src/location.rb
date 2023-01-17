require 'net/http'
require 'uri'
require 'json'

class Location
  attr_reader :data
  def initialize
    api_key = "e26ddee921bd47b9ae05de4c7547ac20"
    url = URI("https://api.geoapify.com/v1/ipinfo?apiKey=#{api_key}")
    res = Net::HTTP.get(url)
    @data = JSON.parse(res)
  end

  def get_coordinates
    location = @data["location"]
    [location["latitude"], location["longitude"]]
  end

  def get_state
    @data["state"]["name"]
  end

  def get_city
    @data["city"]["name"]
  end
end