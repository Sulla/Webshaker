class AddNotificationToComments < ActiveRecord::Migration
  def self.up
    add_column :comments, :notification, :boolean, :default => false
  end

  def self.down
    remove_column :comments, :notification
  end
end
