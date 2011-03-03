class AddUpdatedAtToCodes < ActiveRecord::Migration
  def self.up
    add_column :codes, :updated_at, :datetime
    Code.update_all 'updated_at = created_at'
  end

  def self.down
    remove_column :codes, :updated_at
  end
end
