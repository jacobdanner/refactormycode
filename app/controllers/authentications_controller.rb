class AuthenticationsController < ApplicationController
  before_filter :login_required, :except => [:create, :signin, :signup, :newaccount, :failure]
  
  protect_from_forgery :except => :create     # https://github.com/intridea/omniauth/issues/203


  # GET all authentication authentications assigned to the current user
  def index
    @authentications = current_user.authentications.order('provider asc')
  end

  # POST to remove an authentication authentication
  def destroy
    # remove an authentication authentication linked to the current user
    @authentication = current_user.authentications.find(params[:id])
    
    if session[:authentication_id] == @authentication.id
      flash[:error] = 'You are currently signed in with this account!'
    else
      @authentication.destroy
    end
    
    redirect_to authentications_path
  end

  # POST from signup view
  def newaccount
    if params[:commit] == "Cancel"
      session[:authhash] = nil
      session.delete :authhash
      redirect_to root_url
    else  # create account
      @newuser = User.new
      @newuser.name = session[:authhash][:name]
      @newuser.email = session[:authhash][:email]
      @newuser.authentications.build(:provider => session[:authhash][:provider], :uid => session[:authhash][:uid], :uname => session[:authhash][:name], :uemail => session[:authhash][:email])
      
      if @newuser.save!
        # signin existing user
        # in the session his user id and the authentication id used for signing in is stored
        session[:user] = @newuser.id
        session[:authentication_id] = @newuser.authentications.first.id
        
        flash[:notice] = 'Your account has been created and you have been signed in!'
        redirect_to root_url
      else
        flash[:error] = 'This is embarrassing! There was an error while creating your account from which we were not able to recover.'
        redirect_to root_url
      end  
    end
  end  
  
  # Sign out current user
  def signout 
    if current_user
      session[:user] = nil
      session[:authentication_id] = nil
      session.delete :user
      session.delete :authentication_id
      flash[:notice] = 'You have been signed out!'
    end  
    redirect_to root_url
  end
  
  # callback: success
  # This handles signing in and adding an authentication authentication to existing accounts itself
  # It renders a separate view if there is a new user to create
  def create
    # get the authentication parameter from the Rails router
    params[:service] ? authentication_route = params[:service] : authentication_route = 'No authentication recognized (invalid callback)'

    # get the full hash from omniauth
    omniauth = request.env['omniauth.auth']
    
    # continue only if hash and parameter exist
    if omniauth and params[:service]

      # map the returned hashes to our variables first - the hashes differs for every authentication
      
      # create a new hash
      @authhash = Hash.new
      
      if authentication_route == 'facebook'
        omniauth['extra']['user_hash']['email'] ? @authhash[:email] =  omniauth['extra']['user_hash']['email'] : @authhash[:email] = ''
        omniauth['extra']['user_hash']['name'] ? @authhash[:name] =  omniauth['extra']['user_hash']['name'] : @authhash[:name] = ''
        omniauth['extra']['user_hash']['id'] ?  @authhash[:uid] =  omniauth['extra']['user_hash']['id'].to_s : @authhash[:uid] = ''
        omniauth['provider'] ? @authhash[:provider] = omniauth['provider'] : @authhash[:provider] = ''
      elsif authentication_route == 'github'
        omniauth['user_info']['email'] ? @authhash[:email] =  omniauth['user_info']['email'] : @authhash[:email] = ''
        omniauth['user_info']['name'] ? @authhash[:name] =  omniauth['user_info']['name'] : @authhash[:name] = ''
        omniauth['extra']['user_hash']['id'] ? @authhash[:uid] =  omniauth['extra']['user_hash']['id'].to_s : @authhash[:uid] = ''
        omniauth['provider'] ? @authhash[:provider] =  omniauth['provider'] : @authhash[:provider] = ''  
      elsif ['google', 'yahoo', 'twitter', 'myopenid', 'open_id'].index(authentication_route) != nil
        omniauth['user_info']['email'] ? @authhash[:email] =  omniauth['user_info']['email'] : @authhash[:email] = ''
        omniauth['user_info']['name'] ? @authhash[:name] =  omniauth['user_info']['name'] : @authhash[:name] = ''
        omniauth['uid'] ? @authhash[:uid] = omniauth['uid'].to_s : @authhash[:uid] = ''
        omniauth['provider'] ? @authhash[:provider] = omniauth['provider'] : @authhash[:provider] = ''
      else        
        # debug to output the hash that has been returned when adding new authentications
        render :text => omniauth.to_yaml
        return
      end 
      
      if @authhash[:uid] != '' and @authhash[:provider] != ''
        
        auth = Authentication.find_by_provider_and_uid(@authhash[:provider], @authhash[:uid])

        # if the user is currently signed in, he/she might want to add another account to signin
        if logged_in?
          if auth
            flash[:notice] = 'Your account at ' + @authhash[:provider].capitalize + ' is already connected with this site.'
            redirect_to authentications_path
          else
            current_user.authentications.create!(:provider => @authhash[:provider], :uid => @authhash[:uid], :uname => @authhash[:name], :uemail => @authhash[:email])
            flash[:notice] = 'Your ' + @authhash[:provider].capitalize + ' account has been added for signing in at this site.'
            redirect_to authentications_path
          end
        else
          if auth
            # signin existing user
            # in the session his user id and the authentication id used for signing in is stored
            session[:user] = auth.user.id
            session[:authentication_id] = auth.id
          
            flash[:notice] = 'Signed in successfully via ' + @authhash[:provider].capitalize + '.'
            redirect_to root_url
          else
            # this is a new user; show signup; @authhash is available to the view and stored in the sesssion for creation of a new user
            session[:authhash] = @authhash
            render signup_authentications_path
          end
        end
      else
        flash[:error] =  'Error while authenticating via ' + authentication_route + '/' + @authhash[:provider].capitalize + '. The authentication returned invalid data for the user id.'
        redirect_to signin_path
      end
    else
      flash[:error] = 'Error while authenticating via ' + authentication_route.capitalize + '. The authentication did not return valid data.'
      redirect_to signin_path
    end
  end
  
  # callback: failure
  def failure
    flash[:error] = 'There was an error at the remote authentication. You have not been signed in.'
    redirect_to root_url
  end
end
