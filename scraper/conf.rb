require 'json'
class Conf
    attr_reader :data
    def initialize(data_file)
        file = File.read(data_file)
        @data=JSON.parse(file)
    end
    def to_s
        "https://www.otomoto.pl/osobowe/#{data["Marka"].downcase}/od-#{data["MinYear"]}?search%5Bfilter_float_year%3Ato%5D=#{data["MaxYear"]}&search%5Border%5D=created_at_first%3Adesc"
    end
end