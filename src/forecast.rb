require_relative 'request'
require 'net/http'
require 'json'
require 'uri'
require 'date'
require 'colorize'

class Forecast
  def initialize(coordinates)
    @latitude, @longitude = coordinates
    @forecast = load_full_forecast
  end

  def load_full_forecast
    request_hash = {
      latitude: @latitude,
      longitude: @longitude,
      temperature_unit: "fahrenheit",
      daily: "temperature_2m_max,temperature_2m_min",
      timezone: "auto"
    }

    url_string = Request::build_request_string(
      "https://api.open-meteo.com/v1/forecast",
      request_hash
    )

    url = URI(url_string)
    res = Net::HTTP.get(url)
    return JSON.parse(res)
  end

  def display
    width = 98
    size = width / 7

    border = '-' * width

    header = get_weekdays
      .map{ |weekday| weekday.ljust(size) }
      .join

    highs = get_highs
      .map{ |temp| ("High: #{temp.to_i.to_s} °F").ljust(size).red }
      .join

    lows = get_lows
      .map{ |temp| ("Low:  #{temp.to_i.to_s} °F").ljust(size).blue }
      .join

    puts border
    puts header
    puts border
    puts highs
    puts lows
    puts border
  end

  def get_weekdays
    @forecast["daily"]["time"]
      .map{ |day| Date::ABBR_DAYNAMES[Date.parse(day).wday] }
  end

  def get_highs
    @forecast["daily"]["temperature_2m_max"]
  end

  def get_lows
    @forecast["daily"]["temperature_2m_min"]
  end

  def display_chart_url
    chart_data = {
      "type": "line",
      "data": {
        "labels": get_weekdays,
        "datasets": [
          {
            "backgroundColor": "rgba(0, 0, 0, 0)",
            "borderColor": "rgb(255,150,150)",
            "data": get_highs, 
            "label": "Highs"
          },
          {
            "backgroundColor": "rgba(0, 0, 0, 0)",
            "borderColor": "rgb(0,50,255)",
            "data": get_lows, 
            "label": "Lows"
          },
        ]
      }
    }

    url_string = Request::build_request_string(
      "https://image-charts.com/chart.js/2.8.0",
      {
        chan: nil,
        bkg: 'white',
        c: chart_data.to_json
      }
    )

    title = "View graph of forecast in browser".blue

    puts "\u001b]8;;#{url_string}\u0007#{title}\u001b]8;;\u0007"
  end
end