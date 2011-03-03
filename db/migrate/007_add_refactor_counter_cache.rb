class AddRefactorCounterCache < ActiveRecord::Migration
  def self.up
    add_column :codes, :refactors_count, :integer, :default => 0
  end

  def self.down
    remove_column :codes, :refactors_count
  end
end
