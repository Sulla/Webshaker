class CreateLinks < ActiveRecord::Migration
  def self.up
    create_table :links do |t|
      t.string :url
      t.string :name
      t.integer :link_type_id
      t.integer :linkable_id
      t.string  :linkable_type
      t.timestamps
    end
  end

  def self.down
    drop_table :links
  end
end
