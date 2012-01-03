
class DealsController < ApplicationController
  def index
  	@deal_today = Deal.where(:deal_date => Date.today).order("created_at DESC").first
  end
end
