class Car
    attr_reader :url, :image,:name,:price,:info
    def initialize(url,image,name,price,info)
        @url = url
        @image = image
        @name = name
        @price = price
        @info = info
    end
    def to_s
       "#{@url};#{@image};#{@name};#{@price};#{@info}"
    end
end