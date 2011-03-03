class CreateRatings < ActiveRecord::Migration
  def self.up
    create_table :ratings do |t|
      t.column :user_id, :integer
      t.column :refactor_id, :integer
      t.column :created_at, :datetime
      t.column :value, :integer
    end
    remove_column :refactors, :rating_total
    remove_column :refactors, :rating_count
    remove_column :refactors, :rating
    add_column :refactors, :ratings_count, :integer, :default => 0
    add_column :refactors, :rating, :integer, :default => 0
    
    User.update_all 'rating = 0'
  end

  def self.down
    drop_table :ratings
    add_column :refactors, :rating_total, :integer
    add_column :refactors, :rating_count, :integer
    add_column :refactors, :rating, :integer
    remove_column :refactors, :ratings_count
    remove_column :refactors, :rating
  end
end
