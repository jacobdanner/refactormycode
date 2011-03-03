class AddAlternateIndentityUrlToUsers < ActiveRecord::Migration
  def self.up
    add_column :users, :alternative_identity_url, :string
  end

  def self.down
    remove_column :users, :alternative_identity_url
  end
end
