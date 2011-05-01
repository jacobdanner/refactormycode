class AddFieldsToTaggings < ActiveRecord::Migration
  def self.up
    add_column :taggings, :tagger_id, :integer
    add_column :taggings, :tagger_type, :string
    add_column :taggings, :context, :string    
  end

  def self.down
    remove_column :taggings, :tagger_id
    remove_column :taggings, :tagger_type
    remove_column :taggings, :context
  end
end
