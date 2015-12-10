class CreateCompanies < ActiveRecord::Migration
  def self.up
    create_table :companies do |t|
      t.string :name
      t.string :street
      t.string :zipcode
      t.string :city
      t.string :phone
      t.string :email
      t.float :lat
      t.float :lng

      t.timestamps
    end
  end

  def self.down
    drop_table :companies
  end
end
