require "prawn"
require "prawn/table"

# class Generator
#     def initialize(csv_path,output_path)
#         @csv_path = csv_path
#         @output_path = output_path
#         @data=[]
#         @download_image=[]
#     end
#     def generate_pdf
#         csv_text=File.read(@csv_path)
#         csv = CSV.parse(csv_text,headers: false)
#         pdf = Prawn::Document.new
        
#     end
# end

class Generator
    def initialize(csv_file_path,pdf_output_path)
        @csv_file_path = csv_file_path
        @pdf_output_path = pdf_output_path
    end

    def convert
        Prawn::Document.generate(@pdf_output_path) do
            font_size 14
            table pdf_data,header: false do
                row(0).font_style= :bold
            end
        end
    end

    def pdf_data
        data=[]
        CSV.foreach(@csv_file_path) do |row|
            row_data = row.to_h.values.map do |value|
                if value.start_with?('http')
                    image_path = download_image(value)
                    image_tag(image_path)
                else
                    value
                end
            end
            data << row_data
        end
        data.unshift(CSV.open(@csv_file_path,'r',&readline).chomp.split(","))
        data
    end

    def download_image(url)
        image_data = open(url, allow_redirections: :all).read
        Tempfile.open(['image','.jpg'],'wb') do |file|
            file.write(image_data)
            file.csv_path
        end
    end
    
    def image_tag(image_path)
    {image: image_path,fit:[80,80]}
    end
end