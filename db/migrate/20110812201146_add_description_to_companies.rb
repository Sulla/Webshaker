class AddDescriptionToCompanies < ActiveRecord::Migration
  def self.up
    add_column :companies, :summary, :text
  end

  def self.down
    remove_column :companies, :summary
  end
end
