class CreateDeals < ActiveRecord::Migration
  def change
    create_table :deals do |t|
      t.string :title
      t.float :old_price
      t.float :current_price
      t.string :cover_img
      t.text :description

      t.date :deal_date
      t.string :asin

      t.string :link

      t.timestamps
    end
  end
end
