class AccountsController < ApplicationController
  before_filter :login_required
  
  cache_sweeper :users_sweeper, :only => [:update]
  
  def show
    @user = current_user
  end

  def update
    @user = current_user
    
    if @user.update_attributes(params[:user])
      flash[:notice] = 'Info updated'
      redirect_to account_path
    else
      render :action => 'show'
    end
  end
end
