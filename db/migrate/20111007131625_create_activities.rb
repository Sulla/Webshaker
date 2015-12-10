class CreateActivities < ActiveRecord::Migration
  def self.up
    create_table :activities do |t|
      t.string :noticeable_type
      t.integer :noticeable_id
      t.integer :from_user_id
      t.integer :to_user_id

      t.timestamps
    end
  end

  def self.down
    drop_table :activities
  end
end
