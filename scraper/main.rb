require_relative 'conf.rb'
require_relative 'scraper.rb'
conf = Conf.new('./data.json')
scraper = Scraper.new(conf.to_s)
# scraper.scrape_cars
scraper.get_cars

