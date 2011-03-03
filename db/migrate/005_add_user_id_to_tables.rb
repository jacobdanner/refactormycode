class AddUserIdToTables < ActiveRecord::Migration
  def self.up
    add_column :codes, :user_id,           :integer
    add_column :refactors, :user_id,       :integer
    add_column :refactors, :user_nickname, :string
    add_column :refactors, :user_email,    :string
    add_column :refactors, :user_website,  :string
  end

  def self.down
    remove_column :codes,     :user_id
    remove_column :refactors, :user_id
    remove_column :refactors, :user_nickname
    remove_column :refactors, :user_email
    remove_column :refactors, :user_website
  end
end
