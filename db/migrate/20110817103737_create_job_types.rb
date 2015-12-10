class CreateJobTypes < ActiveRecord::Migration
  def self.up
    create_table :job_types do |t|
      t.string :name
      t.timestamps
    end
    
    add_column :jobs, :job_type_id, :integer
  end

  def self.down
    drop_table :job_types
    remove_column :jobs, :job_type_id
  end
end
