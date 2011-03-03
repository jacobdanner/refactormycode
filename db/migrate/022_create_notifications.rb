class CreateNotifications < ActiveRecord::Migration
  def self.up
    create_table :notifications do |t|
      t.column :code_id, :integer
      t.column :user_id, :integer
      t.column :email, :string
      t.column :name, :string
    end
  end

  def self.down
    drop_table :notifications
  end
end
