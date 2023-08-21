require_relative 'conf.rb'
require_relative 'scraper.rb'
require_relative 'pdf_generator.rb'

conf = Conf.new('./data.json')
scraper = Scraper.new(conf.to_s)
scraper.get_cars
csv_path = "./output.csv"
pdf_path = "./output.pdf"
pdf = Pdf.new(csv_path,pdf_path)
pdf.generate_pdf

