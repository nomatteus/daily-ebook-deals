class Deal < ActiveRecord::Base
  belongs_to :email
  #attr_accessor :old_price, :current_price, :cover_img, :title, :deal_date, :asin, :link

  def self.todays_deal
    Deal.where(:deal_date => Date.today).order("created_at DESC").first
  end

  def self.all_deals_link
    "http://www.amazon.com/gp/feature.html?ie=UTF8&docId=1000677541&tag=ruten-20"
  end

  def affiliate_link
    # Oct 30, 2012: Removing tag from URL because it's causing 404s for some reason
    # Don't want to spend much time looking into this right now, so this is the quick fix
    if self.asin.blank?
      self.link + "&tag=ruten-20"
    else
      "http://www.amazon.com/dp/#{self.asin}/?tag=ruten-20"
    end
  end
end
