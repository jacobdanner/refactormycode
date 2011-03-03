class Notification < ActiveRecord::Base
  belongs_to :code
  belongs_to :user
  
  validates_presence_of :email, :name
  
  [:name, :email].each do |attr|
    define_method attr do
      user ? user[attr] : self[attr]
    end
  end
  
  def self.send_for(refactor)
    # HACK too much spam, removing this for now
    # find_all_by_code_id(refactor.code_id).each do |notification|
    #   unless notification.email == refactor.user_email
    #     CodesMailer.deliver_new_refactoring refactor, notification.name, notification.email
    #   end
    # end
  end
end
