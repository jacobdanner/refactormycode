class UsersController < ApplicationController
  cache_formatted_page :atom, :show
  
  def show
    @user = User.find(params[:id], :include => [:codes, :refactors])
    
    if params[:format] != "html" || read_fragment(:controller => "users", :action => "show", :id => @user).nil?
      @items = (@user.codes + @user.refactors).sort_by(&:created_at).reverse[0, 25]
    end
  end
end
