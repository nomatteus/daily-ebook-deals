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
    # Different formats from http://en.wikipedia.org/wiki/Amazon_Standard_Identification_Number
    asin_match            = deal[:link].match('/(dp|gp/product|o|dp/product)/([a-zA-Z0-9]+)/')
    deal[:asin]           = asin_match[2] if asin_match

    price_table  = inner_doc.css('table tr td div table')[1]

    # Sometimes there is no old price, i.e. for when there is more than one deal (there will also be no ASIN for these)
    if price_table.css('tr td')[1].content.match('/\$[0-9.]+/')
      deal[:old_price]      = price_table.css('tr td')[1].content.strip!.gsub!(/\$/, "")
    end
    deal[:current_price]  = price_table.css('tr td span b')[1].content.strip!.gsub!(/\$/, "")
        
    deal[:deal_date]  = Date.today

    #res = Amazon::Ecs.item_lookup(deal[:asin])
    #ap res

    #ap item/'EditorialReview'

    
    d = Deal.find_or_create_by_asin_and_deal_date(deal[:asin], deal[:deal_date])
    d.update_attributes(deal)
    ap deal

  end

  desc "Send daily email"
  task :send_email_update => :environment do
    h = Hominid::API.new('5d0ef767e66b59f5eeab6c8971fcade6-us4')

    # Assume we are using the first (and only) list
    list = h.lists['data'][0]

    # Check to see that we have a valid deal for today, and that it hasn't been sent yet
    todays_deal = Deal.todays_deal

    if !todays_deal.nil?
      email = Email.find_or_create_by_deal_id(todays_deal.id)
      email.update_attributes({
        :mc_list_id => list["id"],
        :subject => "Daily eBook Deal for " + Date.today.strftime("%A, %B %d, %Y"),
        :from_email => list["default_from_email"],
        :from_name => list["default_from_name"],
        :email_html => ActionView::Base.new(RailsVersion::Application.config.paths["app/views"].first).render(:partial => "emails/template_html", :layout => false, :locals => {:deal => todays_deal}),
        :email_text => ActionView::Base.new(RailsVersion::Application.config.paths["app/views"].first).render(:partial => "emails/template_text", :layout => false, :locals => {:deal => todays_deal})
      })
      todays_deal.update_attributes(:email_id => email.id)
      campaign = email.create_mailchimp_campaign h

      # ap campaign

      # Send to list!
      email.send_mailchimp_campaign h unless email.sent == 1
    else
      raise TodaysDealNotExistException, "There isn't a deal yet for day. Maybe run `rake deals:update` and try again!"
    end
  end
end

class TodaysDealNotExistException < Exception
end

