class CreateJobCategories < ActiveRecord::Migration
  def self.up
    create_table :job_categories do |t|
      t.string :name
      t.timestamps
    end
    
    create_table :job_categories_jobs, :id => false do |t|
      t.integer :job_id
      t.integer :job_category_id
    end
  end

  def self.down
    drop_table :job_categories
    drop_table :job_categories_jobs
  end
end
