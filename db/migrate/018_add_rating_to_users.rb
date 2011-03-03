class AddRatingToUsers < ActiveRecord::Migration
  def self.up
    add_column :users, :rating, :integer, :default => 0
  end

  def self.down
    remove_column :users, :rating
  end
end
