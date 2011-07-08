class BadgesController < ApplicationController
  before_filter :login_required,     :only => [:index]
  skip_filter :find_sidebar_content, :only => [:position]
  skip_filter :login_from_cookie,    :only => [:position]

  def index
    @user = current_user
  end

  def position
    cache_key = {:id => params[:id], :format => params[:format] }
    unless position_image = read_fragment(cache_key)
      @user = User.find(params[:id])
      position_image = @user.position_image
      write_fragment(cache_key, position_image)
    end

    respond_to do |format|
      format.gif do
        send_file position_image, :type => 'image/gif', :disposition => 'inline'
      end
    end
  end
end
