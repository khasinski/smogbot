module AQICN
  class Reading
    include Virtus::ValueObject

    attribute :location, String
    attribute :created_at, DateTime
    attribute :pm25, ReadingItem
    attribute :pm10, ReadingItem
    attribute :no2, ReadingItem
    attribute :co, ReadingItem
    attribute :aqi, ReadingItem
  end
end