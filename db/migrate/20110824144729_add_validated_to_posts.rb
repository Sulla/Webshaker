class AddValidatedToPosts < ActiveRecord::Migration
  def self.up
    add_column :posts, :validated, :boolean, :default => false
    add_column :posts, :accepted_at, :datetime
  end

  def self.down
    remove_column :posts, :validated
    remove_column :posts, :accepted_at
  end
end
