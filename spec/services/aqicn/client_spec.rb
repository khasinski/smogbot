RSpec.describe AQICN::Client do
  let(:invalid_token) { 'invalid_token' }
  let(:valid_token) { ENV['AQICN_API_KEY'] }
  let(:valid_city_name) { 'Poznań' }
  let(:invalid_city_name) { 'Invalid City Name' }
  let(:http_client) { HTTParty }
  let(:valid_key_client) { described_class.new(http_client, valid_token) }
  let(:invalid_key_client) { described_class.new(http_client, invalid_token) }
  let(:valid_result) do
    AQICN::Reading.new(
      aqi: 80,
      co: 0.1,
      no2: 18,
      pm25: 80,
      pm10: 30,
      created_at: Time.parse('Thu, 09 Mar 2017 22:00:00 +0100').to_datetime,
      location: 'Poznań 1 ul. Polanka',
    )
  end

  it 'fetches the data of a valid city with valid API token' do
    VCR.use_cassette('valid_city_valid_token.yml') do
      result = valid_key_client.current_reading_for_city(valid_city_name)
      expect(result).to eq valid_result
    end
  end

  it 'fails on invalid API token' do
    VCR.use_cassette('invalid_token.yml') do
      expect { invalid_key_client.current_reading_for_city(valid_city_name) }.to raise_error AQICN::Errors::InvalidKey
    end
  end

  it 'fails on invalid city name' do
    VCR.use_cassette('invalid_city.yml') do
      expect { valid_key_client.current_reading_for_city(invalid_city_name) }.to raise_error AQICN::Errors::CannotFetchData
    end
  end
end