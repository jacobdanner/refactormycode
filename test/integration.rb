# Allows sexy code to test our cute app!
# Inspired by http://weblog.jamisbuck.org/2006/3/9/integration-testing-in-rails-1-1
module Integration
  module InstanceMethods
    def new_session
      open_session do |session|
        session.extend Integration::SessionExtensions        
        yield session if block_given?
      end
    end
    
    def new_session_as(openid)
      new_session do |session|
        session.login_as openid
        yield session if block_given?
      end
    end
  end
  
  module SessionExtensions
    def login_as(user)
      get login_path
      session[:user] = users(user).id
    end
  end
end

ActionController::IntegrationTest.class_eval do
  include Integration::InstanceMethods
end