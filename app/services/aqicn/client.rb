module AQICN
  class Client
    def initialize(http_client = HTTParty, api_key = ENV['AQICN_API_KEY'])
      @http_client = http_client
      @api_key = api_key
    end

    def current_reading_for_city(city_name)
      response = http_client.get location_url(city_name)
      raise Errors::InvalidKey if invalid_key_response?(response)
      raise Errors::CannotFetchData.new(response['data']) if error_response?(response)
      reading_from_response(response)
    end

    private
    attr_reader :http_client, :api_key

    def location_url(city_name)
      city_name_encoded = URI.encode(city_name)
      "http://api.waqi.info/feed/#{city_name_encoded}/?token=#{api_key.to_s}"
    end

    def error_response?(response)
      response['status'] == 'error'
    end

    def invalid_key_response?(response)
      error_response?(response) && response['data'] == 'Invalid key'
    end

    def reading_from_response(response)
      data = response['data']
      Reading.new({
        location: data['city']['name'],
        aqi: data['aqi'],
        created_at: Time.at(data['time']['v']),
        pm25: data['iaqi']['pm25']['v'],
        pm10: data['iaqi']['pm10']['v'],
        no2: data['iaqi']['no2']['v'],
        co: data['iaqi']['co']['v'],
      })
    end

  end
end