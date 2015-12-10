class AddEventsData < ActiveRecord::Migration
  def self.up
    add_column :events, :street, :string
    add_column :events, :zipcode, :string
    add_column :events, :city, :string
    add_column :events, :access, :string
    add_column :events, :registration, :string
    add_column :events, :lat, :float
    add_column :events, :lng, :float    
  end

  def self.down
    remove_column :events, :street
    remove_column :events, :zipcode
    remove_column :events, :city
    remove_column :events, :access
    remove_column :events, :registration
    remove_column :events, :lat
    remove_column :events, :lng        
  end
end
