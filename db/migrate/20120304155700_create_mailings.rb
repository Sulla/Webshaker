class CreateMailings < ActiveRecord::Migration
  def self.up
    create_table :mailings do |t|
      t.string :model
      t.integer :resource_id
      t.boolean :sent, :default => false

      t.timestamps
    end
  end

  def self.down
    drop_table :mailings
  end
end
