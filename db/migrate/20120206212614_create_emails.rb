class CreateEmails < ActiveRecord::Migration
  def change
    create_table :emails do |t|
      t.string :mc_campaign_id

      t.integer :deal_id

      t.string :mc_list_id
      t.string :mc_campaign_type, :default => 'regular'
      t.string :subject
      t.string :from_email
      t.string :from_name

      t.text :email_html
      t.text :email_text

      t.integer :sent, :default => 0

      t.timestamps
    end
  end
end
