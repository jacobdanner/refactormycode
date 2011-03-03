class AddRefactorsCountToUsers < ActiveRecord::Migration
  def self.up
    add_column :users, :refactors_count, :integer, :default => 0
    User.reset_column_information
    User.find(:all).each { |user| user.update_attribute :refactors_count, user.refactors(true).size }
  end

  def self.down
    remove_column :users, :refactors_count
  end
end
