class AddRatingTotalToRefactors < ActiveRecord::Migration
  def self.up
    add_column :refactors, :rating_total, :integer
    add_column :refactors, :rating_count, :integer
  end

  def self.down
    remove_column :refactors, :rating_total
    remove_column :refactors, :rating_count
  end
end
