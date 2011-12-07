require 'open-uri'

class DealsController < ApplicationController
  def index
    kindle_uri = "http://www.amazon.com/gp/feature.html?ie=UTF8&docId=1000677541"
    
    doc = Nokogiri::HTML(open(kindle_uri))
    
    deal_html = ""
    
    doc.css('td .amabot_center > table:first').each do |table|
      deal_html += table.to_s
    end
    
    @deal = deal_html
  end

end
