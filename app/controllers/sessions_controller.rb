class SessionsController < ApplicationController
  cache_sweeper :users_sweeper, :only => [:create]
  
  def new
    if logged_in?
      redirect_to account_path
    else
      session[:return_to] = params[:return_to] if params[:return_to]
    end
  end

  def create
    open_id_authentication(params[:openid_url])
  end

  def destroy
    clear_cookies
    reset_session
    flash[:notice] = "You have been logged out."
    redirect_to home_url
  end

  protected

  def open_id_authentication(openid_url)
    if Rails.env.development?
      self.current_user = User.first
      successful_login
    else
      # the below code should be updated to omniauth.
      authenticate_with_open_id(openid_url, :required => [:nickname, :email]) do |result, identity_url, registration|
        if result.successful?
          # self.current_user = User.find_or_create_by_identity_url(identity_url, registration.data)
          # successful_login
        else
          failed_login result.message
        end
      end
    end
  rescue OpenIdAuthentication::InvalidOpenId => e
    failed_login e.message
  end

  def failed_login(message = "Authentication failed.")
    flash.now[:error] = message
    render :action => 'new'
  end

  def successful_login
    cookies[:token] = { :value => self.current_user.create_token! , :expires => 5.years.since }
    cookies[:admin] = { :value => 'true' , :expires => 5.years.since } if current_user.admin?
    
    redirect_to session[:return_to] || home_url
    session[:return_to] = nil
  end
end