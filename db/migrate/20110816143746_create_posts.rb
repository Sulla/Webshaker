class CreatePosts < ActiveRecord::Migration
  def self.up
    create_table :posts do |t|
      t.string :title
      t.text :content
      t.integer :post_type_id

      t.timestamps
    end
  end

  def self.down
    drop_table :posts
  end
end
