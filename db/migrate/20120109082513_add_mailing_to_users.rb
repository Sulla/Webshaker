class AddMailingToUsers < ActiveRecord::Migration
  def self.up
    add_column :users, :mailing, :boolean, :default => true
  end

  def self.down
    remove_column :users, :mailing
  end
end
