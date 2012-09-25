class Deal < ActiveRecord::Base
  belongs_to :email
  #attr_accessor :old_price, :current_price, :cover_img, :title, :deal_date, :asin, :link

  def self.todays_deal
    Deal.where(:deal_date => Date.today).order("created_at DESC").first
  end

  def affiliate_link
    if self.asin.blank?
      self.link + "&tag=ruten-20"
    else
      "http://www.amazon.com/dp/#{self.asin}/?tag=ruten-20"
    end
  end
end
