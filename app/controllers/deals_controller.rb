
class DealsController < ApplicationController
  def index
  	@deal_today = Deal.where(:deal_date => Date.now)
  end
end
