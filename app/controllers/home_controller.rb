require 'open-uri'
class HomeController < ApplicationController

    def show
        @remote_page = RemotePage.new
        data_table = GoogleVisualr::DataTable.new
        data_table_letters = GoogleVisualr::DataTable.new

        if params[:remote_page].present? && params[:remote_page][:url].present?
            begin
                doc = Nokogiri::HTML(open(params[:remote_page][:url]))
                @remote_page = RemotePage.new(params[:remote_page][:url], doc)
                # Add Column Headers
                data_table.new_column('string', 'HTML tag' )
                data_table.new_column('number', 'Ilość')
                # Add Rows and Values
                data_table.add_rows(@remote_page.html_tags)
                option = { width: "90%", height: 400, title: 'Występowanie znaczników HTML',
                    hAxis:{showTextEvery:1, slantedText: true, slantedTextAngle: 30}}
                @chart = GoogleVisualr::Interactive::ColumnChart.new(data_table, option)
                # Letters Chart
                data_table_letters.new_column('string', 'Litera')
                data_table_letters.new_column('number', 'Ilość')
                @letters = @remote_page.letters
                data_table_letters.add_rows(@letters[0..19])
                option2 = { width: "90%", height: 400, title: 'Występowanie liter (TOP 20)',
                   hAxis:{showTextEvery:1}}
                @chart_letters = GoogleVisualr::Interactive::ColumnChart.new(data_table_letters, option2)

            rescue 
                flash[:error] = "Niepoprawny URL lub strona internetowa nie odpoiwada"
                render action: 'show'
            end
        end
    end
end
