class CreateWorkers < ActiveRecord::Migration
  def self.up
    create_table :workers do |t|
      t.integer :user_id
      t.integer :company_id
      t.string :title
      t.boolean :admin, :default => false
      t.boolean :removable, :default => true
      t.boolean :validated, :default => false

      t.timestamps
    end
  end

  def self.down
    drop_table :workers
  end
end
