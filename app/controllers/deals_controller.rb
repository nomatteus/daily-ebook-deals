require 'open-uri'

class DealsController < ApplicationController
  def index
    kindle_uri = "http://www.amazon.com/gp/feature.html?ie=UTF8&docId=1000677541"
    
    doc = Nokogiri::HTML(open(kindle_uri))
    
    deal_html = ""
    
    doc.css('td .amabot_center > table:first').each do |table|
      deal_html += table.to_s
    end

    # New Nokogiri node with isolated deal html only
    inner_doc = Nokogiri::HTML(deal_html)

    #puts inner_doc.inspect

    book = {}
    book[:cover]            = inner_doc.css('span a img')[0]
    book[:title]            = inner_doc.css('span p b a')[0]
    book[:description]      = inner_doc.css('table tr td div span')[2]

    price_table  = inner_doc.css('table tr td div table')[1]
    @ap1 = ap price_table.css('tr td')

    #book[:price_yesterday]  = inner_doc.css('')[1]
    #book[:price_deal]       = inner_doc.css('span p b a')[0]


    @ap2 = ap book

    
    @deal = deal_html
  end

end
