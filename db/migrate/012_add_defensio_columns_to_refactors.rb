class AddDefensioColumnsToRefactors < ActiveRecord::Migration
  def self.up
    add_column :refactors, :spam,      :boolean, :default => false
    add_column :refactors, :spaminess, :float
    add_column :refactors, :signature, :string
  end

  def self.down
    remove_column :refactors, :spam
    remove_column :refactors, :spaminess
    remove_column :refactors, :signature
  end
end
