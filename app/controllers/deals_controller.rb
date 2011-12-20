
class DealsController < ApplicationController
  def index
  	@deal_today = Deal.where(:deal_date => Date.today).first
  end
end
