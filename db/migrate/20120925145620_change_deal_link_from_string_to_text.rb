class ChangeDealLinkFromStringToText < ActiveRecord::Migration
  def change
    change_column :deals, :link, :text
  end
end
