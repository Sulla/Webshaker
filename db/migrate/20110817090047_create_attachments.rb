class CreateAttachments < ActiveRecord::Migration
  def self.up
    create_table :attachments do |t|
      t.integer :post_id
      t.integer :user_id
      t.boolean :online
      t.string :name
      t.string :picture_file_name
      t.string :picture_content_type
      t.integer :picture_file_size
      t.datetime :picture_updated_at
      t.timestamps
    end
  end

  def self.down
    drop_table :attachments
  end
end