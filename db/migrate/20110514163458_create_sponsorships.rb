class CreateSponsorships < ActiveRecord::Migration
  def self.up
    create_table :sponsorships do |t|
      t.integer :user_id
      t.integer :post_id

      t.timestamps
    end
  end

  def self.down
    drop_table :sponsorships
  end
end
