require 'httparty'
require 'nokogiri'
require 'open-uri'
require_relative 'car.rb'
class Scraper
    attr_reader :cars
    def initialize(url)
        @cars=[]
        @document = get_doc(url)
    end
    def get_doc(url)
        response = HTTParty.get(url,{
            headers:{
                "User-Agent" => "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/109.0.0.0 Safari/537.36"
            },
        })
        Nokogiri::HTML(response.body)
    end
    def scrape_cars
        html_cars = @document.css('main').css('article').css('section')
        html_cars.each do |html_car|
            car = scrape_car(html_car)
            @cars.push(car)
        end
    end
    def scrape_car(car)
        # url = car.css("div")[1].css("h1").css("a").first.attribute("href").value
        url = car.css("div h1 a").first.attribute("href").value
        name = car.css('h1').css('a').first.text
        img_src = car.css("div")[0].css("img").attribute("src")
        if img_src.nil?
            image="lack;s=0"
        else
            image = img_src
        end
          # image = car.css("div img").attribute("src")
        price = car.css('div h3').text
        info = scrape_info(url)
        Car.new(url,image,name,price,info)
    end
    def scrape_info(url)
        doc = get_doc(url)
        year_of_production = doc.css('span.offer-params__label:contains("Rok produkcji")+div.offer-params__value').text.strip
        type_of_fuel = doc.css('span.offer-params__label:contains("Rodzaj paliwa")+div.offer-params__value a').text.strip
        engine_size = doc.css('span.offer-params__label:contains("Pojemność skokowa")+div.offer-params__value').text.strip
        mileage = doc.css('span.offer-params__label:contains("Przebieg")+div.offer-params__value').text.strip
        color = doc.css('span.offer-params__label:contains("Kolor")+div.offer-params__value').text.strip
        liftback = doc.css('span.offer-params__label:contains("Typ nadwozia")+div.offer-params__value').text.strip
        "#{year_of_production};#{mileage};#{engine_size};#{type_of_fuel};#{color};#{liftback}" 
    end
    def write_to_csv
        CSV.open("output.csv","w") do |csv|
            @cars.each do |car|
                csv << car.to_s.split(";")
            end
        end
    end
    def get_cars
        scrape_cars
        write_to_csv
    end
end