class CreateRefactors < ActiveRecord::Migration
  def self.up
    create_table :refactors do |t|
      t.column :code_id,    :integer
      t.column :title,       :string
      t.column :description, :text
      t.column :content,     :text
      t.column :language,    :string
      t.column :created_at,  :datetime
    end
  end

  def self.down
    drop_table :refactors
  end
end
