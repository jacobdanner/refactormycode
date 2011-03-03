class AddPermalinkToCodes < ActiveRecord::Migration
  def self.up
    add_column :codes, :permalink, :string
    Code.reset_column_information
    Code.find(:all).each &:save!
  end

  def self.down
    remove_column :codes, :permalink
  end
end
