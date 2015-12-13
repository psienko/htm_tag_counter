require 'open-uri'
class HomeController < ApplicationController

    def show
        @remote_page = RemotePage.new
        data_table = GoogleVisualr::DataTable.new

        if params[:remote_page].present? && params[:remote_page][:url].present?
            begin
                doc = Nokogiri::HTML(open(params[:remote_page][:url]))
                @remote_page = RemotePage.new(params[:remote_page][:url], doc)
                # Add Column Headers
                data_table.new_column('string', 'HTML tag' )
                data_table.new_column('number', 'Ilość')
                # Add Rows and Values
                data_table.add_rows(@remote_page.html_tags)
                option = { width: "100%", height: 400, title: 'Występowanie znaczników HTML',
                    hAxis:{showTextEvery:1}}
                @chart = GoogleVisualr::Interactive::ColumnChart.new(data_table, option)
            rescue 
                flash[:error] = "Niepoprawny URL lub strona internetowa nie odpoiwada"
                render action: 'show'
            end
        end
    end
end
