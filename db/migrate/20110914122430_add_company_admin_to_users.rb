class AddCompanyAdminToUsers < ActiveRecord::Migration
  def self.up
    add_column :users, :company_admin_request, :boolean
  end

  def self.down
    remove_column :users, :company_admin_request
  end
end
