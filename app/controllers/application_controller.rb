class ApplicationController < ActionController::Base
  include ExceptionNotifiable
  include CacheableFlash
  include CachingExtensions::Caching
  
  helper :all # include all helpers, all the time

  # See ActionController::RequestForgeryProtection for details
  # If you're using the Cookie Session Store you can leave out the :secret
  protect_from_forgery :secret => '45d2cbfe36ca05f80bb6ce48328b48cd'
  
  before_filter :login_from_cookie
  before_filter :find_sidebar_content
  
  helper_method :current_user, :logged_in?, :admin?, :author_of_code?, :author_of_refactor?
  
  protected
    def root_url
      home_url
    end
  
    def find_sidebar_content
      unless read_fragment('sidebar')
        @recent_codes = Code.find(:all, :order => 'created_at desc', :limit => 10)
        @popular_codes = Code.find(:all, :order => Code.popular_sql_order, :limit => 10)
      end
    end
    
    def current_user
      @current_user ||= User.find_by_id(session[:user])
    end
    
    def current_user=(user)
      session[:user] = user.id
    end
    
    def logged_in?
      !self.current_user.nil?
    end
    
    def admin?
      logged_in? && self.current_user.admin
    end
    
    def login_required
      return true if logged_in?
      flash[:notice] = 'Please login to do this'
      redirect_to login_path
      false
    end
    
    def admin_required
      return true if admin?
      flash[:notice] = "Only admins can do this"
      redirect_to home_path
      false
    end
    
    def author_of_code?
      logged_in? && (admin? || @code.user == self.current_user)
    end
    
    def author_of_refactor?(refactor)
      logged_in? && (admin? || refactor.user == self.current_user)
    end
    
    def author_of_code_required
      return true if author_of_code?
      flash[:notice] = "Only the author can do this"
      redirect_to code_path(@code)
      false
    end   
    
    def login_from_cookie
      return unless cookies[:token] && !logged_in?
      user = User.find_by_token(cookies[:token])
      if user && user.token?
        self.current_user = user
      else
        clear_cookies
      end
    end
    
    def clear_cookies
      cookies.delete :admin
      cookies.delete :token
    end
end
