class AuthenticationsController < ApplicationController
  def index
    render :text => request.env["omniauth.auth"].to_yaml   
  end  
    
  def create  
    render :text => request.env["omniauth.auth"].to_yaml  
  end  
    
  def destroy
    render :text => request.env["omniauth.auth"].to_yaml   
  end
end
