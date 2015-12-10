class AddValidatedToSchoolsAndCompanies < ActiveRecord::Migration
  def self.up
    add_column :schools, :validated, :boolean, :default => false
    add_column :companies, :validated, :boolean, :default => false
  end

  def self.down
    remove_column :schools, :validated
    remove_column :companies, :validated    
  end
end
