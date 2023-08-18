require "prawn"
require "prawn/table"

class Generator
    def initialize(csv_path,output_path)
        @csv_path = csv_path
        @output_path = output_path
        @data=[]
        @download_image=[]
    end
    def generate_pdf
        csv_text=File.read(@csv_path)
        csv = CSV.parse(csv_text,headers: false)
        pdf = Prawn::Document.new
        
    end
end