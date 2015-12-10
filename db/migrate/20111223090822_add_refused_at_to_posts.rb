class AddRefusedAtToPosts < ActiveRecord::Migration
  def self.up
    add_column :posts, :refused_at, :datetime
    add_column :posts, :online, :boolean, :default => true    
  end

  def self.down
    remove_column :posts, :refused_at
    remove_column :posts, :online    
  end
end
