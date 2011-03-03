class Friendship < ActiveRecord::Base
  belongs_to :user
  belongs_to :friend, :class_name => "User"
  
  validates_uniqueness_of :friend_id, :scope => :user_id

  validate do |record|
    record.errors.add :base, "You can't friend yourself" if record.user_id == record.friend_id
  end
end
