require_relative 'location'
require_relative 'forecast'
require 'colorize'

class App
  def self.run
    puts "Welcome to the Ruby weather forecasting app!".blue
    puts "Loading the weather forecast for your location...\n"
    begin 
      location = Location.new
      forecast = Forecast.new(location.get_coordinates)
      puts "Here's the forecast for " + ("#{location.get_city}, #{location.get_state}.".green)
      puts ''
      forecast.display_chart_url
      puts ''
      forecast.display
    rescue
      puts "Unfortunatly, there was an error loading your weather information."
    end
  end
end

