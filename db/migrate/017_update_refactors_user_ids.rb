class UpdateRefactorsUserIds < ActiveRecord::Migration
  def self.up
    Refactor.update_all 'user_id = (SELECT id FROM users WHERE users.name = refactors.user_name LIMIT 1)'
  end

  def self.down
    Refactor.update_all 'user_id = NULL'
  end
end
