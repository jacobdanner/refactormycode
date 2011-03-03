class ChangeRatingTypeOnRefactors < ActiveRecord::Migration
  def self.up
    change_column :users, :rating, :float
  end

  def self.down
    change_column :users, :rating, :integer
  end
end
