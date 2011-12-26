require 'open-uri'
require 'amazon/ecs'

Amazon::Ecs.options = {
  :associate_tag => 'ruten-20',
  :AWS_access_key_id => 'AKIAJTELTYBX2BD6E22A',
  :AWS_secret_key => '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'
}

namespace :deals do
  desc "Update Kindle Daily deal"
  task :update => :environment do 

    kindle_uri = "http://www.amazon.com/gp/feature.html?ie=UTF8&docId=1000677541"
    
    doc = Nokogiri::HTML(open(kindle_uri))
    
    deal_html = ""
    
    doc.css('td .amabot_center > table:first').each do |table|
      deal_html += table.to_s
    end

    # New Nokogiri node with isolated deal html only
    inner_doc = Nokogiri::HTML(deal_html)

    #puts inner_doc.inspect

    deal = {}
    deal[:cover_img]      = inner_doc.css('span a img')[0]['src']
    deal[:title]          = inner_doc.css('span p b a')[0].content.gsub!(/Kindle Daily Deal: /, "")
    deal[:description]    = inner_doc.css('table tr td div span')[2].content.strip!
    deal[:link]           = "http://www.amazon.com" + inner_doc.css('a')[0]['href']
    asin_match            = deal[:link].match('/dp/([a-zA-Z0-9]+)/')
    deal[:asin]           = asin_match[1] if asin_match

    price_table  = inner_doc.css('table tr td div table')[1]

    deal[:old_price]      = price_table.css('tr td')[1].content.strip!.gsub!(/\$/, "")
    deal[:current_price]  = price_table.css('tr td span b')[1].content.strip!.gsub!(/\$/, "")
        
    deal[:deal_date]  = Date.today

    #res = Amazon::Ecs.item_lookup(deal[:asin])
    #ap res

    #ap item/'EditorialReview'

    
    d = Deal.find_or_create_by_asin_and_deal_date(deal[:asin], deal[:deal_date])
    d.update_attributes(deal)
    ap deal

  end
end

