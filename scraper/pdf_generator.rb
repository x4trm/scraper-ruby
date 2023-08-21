require 'csv'
require 'prawn'
require 'net/http'
require 'net/https'
require 'uri'
require 'prawn/table'

class Pdf
    def initialize(csv_file_path,pdf_file_path)
        @csv_file_path = csv_file_path
        @pdf_file_path = pdf_file_path
        @data = []
        @downloaded_files = []
    end
    def generate_pdf
        csv_text = File.read(@csv_file_path)
        csv = CSV.parse(csv_text.scrub)
        pdf = Prawn::Document.new
        counter = 1
        csv.each do |row|
            if row[1]=~URI::regexp
                add_image_row(row,counter)
                # add_row(row)
                counter+=1
            else
                add_row(row)
            end
        end
        pdf.table(@data, header: false,column_widths: {0 => 120, 1 => 100, 2 => 70})
        pdf.render_file(@pdf_file_path)
        @downloaded_files.each do |file|
            File.delete(file)
        end
    end
    def add_row(row_data)
        @data << row_data
    end
    def add_image_row(row,counter)
        img_url = URI.extract(row[1])[0]
        uri = URI(img_url)
        Net::HTTP.start(uri.host,uri.port, :use_ssl => uri.scheme == 'https') do |http|
            # http.use_ssl = true 
            resp = http.get(uri.path)
            file_name = "#{counter}_#{File.basename(uri.path)}"
            File.open(file_name,"wb") do |file|
                file.write(resp.body)
            end
            @downloaded_files << file_name
            @data << [{image: file_name,fit: [100,100]},row[2],row[3],row[4],row[5],row[6],row[7]]
        end
    end
end