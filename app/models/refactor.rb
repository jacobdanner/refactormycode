class Refactor < ActiveRecord::Base
  # here we must use profanity default way to do filter. it supports the profanity_filtered? below!
  profanity_filter :title, :comment, :code
  
  belongs_to :refactored_code, :class_name => "Code", :foreign_key => "code_id"
  belongs_to :user
  has_many   :ratings

  validates_presence_of :language, :user_name, :code_id
  validate              :presence_of_comment_or_code
  validate              :email_if_notify_me

  attr_accessor :notify_me

  acts_as_defensio_comment :fields => { :author       => :user_name,
                                        :author_email => :user_email,
                                        :author_url   => :user_website,
                                        :article      => :refactored_code }

  after_create  { |refactor| refactor.send_notifications unless refactor.spam }
  after_create  :create_notification
  # before_save   { |refactor| refactor.disable_ferret if refactor.spam }
  after_create  { |refactor| refactor.update_counter_caches unless refactor.spam }
  after_destroy { |refactor| refactor.update_counter_caches :decrement unless refactor.spam }

  attr_accessible :title, :comment, :code, :language,
                  :user_name, :user_email, :user_website,
                  :notify_me

  [:name, :email, :website].each do |attr|
    define_method "user_#{attr}" do
      user ? user[attr] : self[:"user_#{attr}"]
    end
  end

  def create_notification
    if notify_me == '1' && Notification.find_by_code_id_and_email(code_id, user_email).nil?
      Notification.create :code => refactored_code, :user => user,
                          :name => user_name, :email => user_email
    end
  end

  def update_counter_caches(direction=:increment)
    user(true).send "#{direction}!", :refactors_count if user_id
    refactored_code(true).send "#{direction}!", :refactors_count
  end

  def send_notifications
    Notification.send_for self
  end

  def content
    [self.comment.to_s, self.code.to_s] * "\n"
  end

  def profanity_filtered?
    "#{self.title} #{self.comment} #{self.code}".include?('@#$')
  end
  
  def title
    "On #{refactored_code.title}"
  end

  def trusted_user
    user_logged_in && (self.user.admin || self.user == refactored_code.user)
  end

  def user_logged_in
    !self.user.nil?
  end

  def report_as_spam_with_counter_cache
    update_counter_caches :decrement
    report_as_spam_without_counter_cache
  end
  alias_method_chain :report_as_spam, :counter_cache

  def report_as_ham_with_counter_cache
    update_counter_caches :increment
    send_notifications
    report_as_ham_without_counter_cache
  end
  alias_method_chain :report_as_ham, :counter_cache

  private
    def presence_of_comment_or_code
      errors.add :comment, 'or code is required' if comment.blank? && code.blank?
    end

    def email_if_notify_me
      errors.add :user_email, 'is required for notification' if user_email.blank? && notify_me == '1'
    end
end
