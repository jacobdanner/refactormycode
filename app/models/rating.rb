class Rating < ActiveRecord::Base
  belongs_to :refactor
  belongs_to :user
  
  validates_presence_of   :value, :user_id
  validates_uniqueness_of :user_id, :scope => :refactor_id, :on => :create,
                          :message => "has already rated this refactoring"
  validate_on_create      :validate_not_owner
  
  after_create :cache_rating
  
  attr_protected :user, :user_id
  
  def cache_rating
    refactor.increment! :ratings_count # counter_cache doesn't seem to work!
    refactor.update_attribute :rating, refactor.ratings.collect(&:value).sum / refactor.ratings.size
    refactor.user.update_attribute :rating,
      Refactor.average(:rating, :conditions => ['user_id = ? AND rating <> 0', refactor.user_id]) if refactor.user
  end
  
  def validate_not_owner
    errors.add :user_id, "can't vote on his own refactoring" if self.user_id == refactor.user_id
  end
end
