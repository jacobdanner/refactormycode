class CreateCodes < ActiveRecord::Migration
  def self.up
    create_table :codes do |t|
      t.column :title,       :string
      t.column :description, :text
      t.column :content,     :text
      t.column :language,    :string
      t.column :created_at,  :datetime
    end
  end

  def self.down
    drop_table :codes
  end
end
