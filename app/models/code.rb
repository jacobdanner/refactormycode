class Code < ActiveRecord::Base
  has_many :refactors, :conditions => { :spam => false }, :dependent => :destroy
  belongs_to :user
  
  has_permalink :title
  attr_accessor :notify_me
  
  validates_presence_of :title, :comment, :code, :language, :user_id
  validate              :email_if_notify_me
  
  acts_as_defensio_article :fields => { :author       => :user_name,
                                        :author_email => :user_email,
                                        :content      => :comment,
                                        :permalink    => :permalink_url }

  # acts_as_ferret :fields => [:title, :comment, :code, :language, :tag_list],
  #                :single_index => true
  
  delegate :name, :to => :user, :prefix => true

  acts_as_taggable_on :tags
  
  attr_protected :user_id, :user
  
  after_save     :create_notification
  
  def to_param
    "#{id}-#{permalink}"
  end
  
  def user_email
    user.email || "no-email@refactormycode.com"
  end
  
  def permalink_url
    if ENV['RAILS_ENV'] == 'production'
      "http://refactormycode.com/codes/#{to_param}"
    else
      "http://refactormycode-dev.com/codes/#{to_param}"
    end
  end
  
  def self.popular_sql_order
    case connection.adapter_name
    when /MySQL/
      "DATE_FORMAT(codes.created_at, '%x%m') desc, codes.refactors_count desc"
    when /PostgreSQL/
      "to_char(codes.created_at, 'YYYYMM') desc, codes.refactors_count desc"
    else
      '1'
    end
  end
  
  def self.search(text, options={})
    find_with_ferret(text, { :models => :all }.merge(options))
  end
  
  private
    def email_if_notify_me
      errors.add :user, 'email is required for notification' if (user.nil? || user.email.blank?) && notify_me == '1'
    end
  
    def create_notification
      if notify_me == '1' && Notification.find_by_code_id_and_email(id, user.email).nil?
        Notification.create :code => self, :user => user,
                            :name => user.name, :email => user.email
      end
    end
end
