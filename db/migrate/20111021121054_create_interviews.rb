class CreateInterviews < ActiveRecord::Migration
  def self.up
    create_table :interviews do |t|
      t.integer :post_id
      t.string :movie_url

      t.timestamps
    end
  end

  def self.down
    drop_table :interviews
  end
end
