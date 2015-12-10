class AddUserFields < ActiveRecord::Migration
  def self.up
    add_column :users, :school_id, :integer
    add_column :users, :company_id, :integer
    add_column :users, :freelance_name, :string
    add_column :users, :job_title, :string    
  end

  def self.down
    remove_column :users, :school_id
    remove_column :users, :company_id
    remove_column :users, :freelance_name
    remove_column :users, :job_title    
  end
end
