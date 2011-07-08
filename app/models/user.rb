require 'digest/sha1'
class User < ActiveRecord::Base
  has_many :codes
  has_many :refactors, :conditions => { :spam => false }
  has_many :ratings
  has_many :friendships
  has_many :friends, :through => :friendships, :class_name => "User"
  has_many :authentications

  alias_attribute :nickname, :name

  attr_protected :admin, :rating, :refactors_count

  before_create :generate_missing_name

  alias_method :fans, :friends

  def create_token!
    self.token = Digest::SHA1.hexdigest("--#{Time.now.to_s}--#{name}--")
    save(false)
    self.token
  end

  def position
    User.find(:all, :order      => 'rating desc, refactors_count desc',
                    :conditions => ['rating >= ?', rating.to_i]).index(self) + 1
  end

  def rated?(refactor)
    ratings.any? { |rating| rating.refactor == refactor }
  end

  def position_image
    image = if position < 10
      position
    elsif position < 100
      "top#{(position.to_f / 10.0).ceil}0"
    elsif position < 1000
      'top1000'
    elsif position < 1000
      'top1000'
    else
      'top10000'
    end

    "#{RAILS_ROOT}/public/images/positions/#{image}.gif"
  end

  private
    def generate_missing_name
      self.name = self.authentications.map(&:uname).compact.first if name.blank?
    end
end
