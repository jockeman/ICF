class AddIgnore < ActiveRecord::Migration
  def self.up
    add_column :users, :ignored, :boolean, :default => false
  end

  def self.down
    remove_column :users, :ignored
  end
end
