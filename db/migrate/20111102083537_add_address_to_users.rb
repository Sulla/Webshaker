class AddAddressToUsers < ActiveRecord::Migration
  def self.up
    add_column :users, :street, :string
    add_column :users, :zipcode, :string
    add_column :users, :city, :string
    add_column :users, :lat, :float
    add_column :users, :lng, :float    
  end

  def self.down
    remove_column :users, :street
    remove_column :users, :zipcode
    remove_column :users, :city
    remove_column :users, :lat
    remove_column :users, :lng        
  end
end
