class RenameNameAndContent < ActiveRecord::Migration
  def self.up
    rename_column :codes,     :content,       :code
    rename_column :codes,     :description,   :comment
    rename_column :users,     :nickname,      :name
    rename_column :refactors, :content,       :code
    rename_column :refactors, :description,   :comment
    rename_column :refactors, :user_nickname, :user_name

    add_column    :users,      :website,       :string
  end

  def self.down
    rename_column :codes,     :code,      :content
    rename_column :codes,     :comment,   :description
    rename_column :users,     :name,      :nickname
    rename_column :refactors, :code,      :content
    rename_column :refactors, :comment,   :description
    rename_column :refactors, :user_name, :user_nickname
    remove_column :users,     :website
  end
end
