class CreateJobs < ActiveRecord::Migration
  def self.up
    create_table :jobs do |t|
      t.integer :post_id
      t.integer :company_id
      t.text :skills
      t.text :how_to_apply

      t.timestamps
    end
  end

  def self.down
    drop_table :jobs
  end
end
