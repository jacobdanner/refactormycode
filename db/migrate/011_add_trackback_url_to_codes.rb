class AddTrackbackUrlToCodes < ActiveRecord::Migration
  def self.up
    add_column :codes, :trackback_url, :string
  end

  def self.down
    remove_column :codes, :trackback_url
  end
end
