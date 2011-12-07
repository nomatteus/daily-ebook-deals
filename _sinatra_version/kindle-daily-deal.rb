class KindleDailyDeal < Sinatra::Base

  #helpers Sinatra::Partials
  
  configure(:production, :development) do
    enable :logging
  end
  
  get '/' do
    kindle_uri = "http://www.amazon.com/gp/feature.html?ie=UTF8&docId=1000677541"
    
    doc = Nokogiri::HTML(open(kindle_uri))
    
    deal_html = ""
    
    doc.css('td .amabot_center > table:first').each do |table|
      deal_html += table.to_s
    end
    
    deal_html
  end

end