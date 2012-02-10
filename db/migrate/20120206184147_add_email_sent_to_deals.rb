class AddEmailSentToDeals < ActiveRecord::Migration
  def change
    add_column :deals, :email_id, :integer
  end
end
