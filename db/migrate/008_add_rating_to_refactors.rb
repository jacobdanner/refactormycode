class AddRatingToRefactors < ActiveRecord::Migration
  def self.up
    add_column :refactors, :rating, :integer
  end

  def self.down
    remove_column :refactors, :rating
  end
end
