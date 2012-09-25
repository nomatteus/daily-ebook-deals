
class DealsController < ApplicationController
  def index
  	@deal_today = Deal.where(:deal_date => Date.today).order("created_at DESC").first
  end

  # Mostly for testing!
  def email
    todays_deal = Deal.todays_deal
    render(:partial => "emails/template_html", :layout => false, :locals => {:deal => todays_deal})
  end

  def email_txt
    todays_deal = Deal.todays_deal
    render(:partial => "emails/template_text", :layout => false, :locals => {:deal => todays_deal})
  end
end
