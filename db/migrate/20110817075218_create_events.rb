class CreateEvents < ActiveRecord::Migration
  def self.up
    create_table :events do |t|
      t.integer :post_id
      t.datetime :occurs_on

      t.timestamps
    end
  end

  def self.down
    drop_table :events
  end
end
