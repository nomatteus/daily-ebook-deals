class Deal < ActiveRecord::Base
  belongs_to :email
  #attr_accessor :old_price, :current_price, :cover_img, :title, :deal_date, :asin, :link

  def self.todays_deal
    Deal.where(:deal_date => Date.today).first
  end
end
