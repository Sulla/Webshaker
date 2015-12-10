class AddBaselineToCompany < ActiveRecord::Migration
  def self.up
    add_column :companies, :baseline, :string
  end

  def self.down
    remove_column :companies, :baseline
  end
end
