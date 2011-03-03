class FriendsController < ApplicationController
  before_filter :login_required, :except => :show
  before_filter :find_user
  
  def show
    @items = (Code.find(:all, :conditions => { :user_id => @user.friend_ids }, :limit => 25) +
              Refactor.find(:all, :conditions => { :user_id => @user.friend_ids }, :limit => 25)).
              sort_by(&:created_at).reverse[0, 25]
  end
  
  def create
    @friendship = current_user.friendships.build(:friend => @user)
    
    @success = @friendship.save
    
    respond_to :js
  end
  
  def destroy
    @friendships = current_user.friendships.find_by_friend_id(@user) || raise(ActiveRecord::RecordNotFound, "Not in friendship")
    @friendships.destroy
    
    respond_to :js
  end
  
  private
    def find_user
      @user = User.find(params[:user_id])
    end
end
