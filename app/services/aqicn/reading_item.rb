module AQICN
  class ReadingItem
    def initialize(aqicn_item)
      @value = aqicn_item['v']
    end

    def to_json(*)
      @value
    end

    private
    attr_reader :value
  end
end