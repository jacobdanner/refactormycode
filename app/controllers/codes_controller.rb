class CodesController < ApplicationController
  before_filter :find_code,               :only   => [:edit, :update, :destroy, :pastable, :follow]
  before_filter :login_required,          :except => [:index, :show, :pastable]
  before_filter :author_of_code_required, :only   => [:edit, :update]
  before_filter :find_tags,               :only   => [:new, :create, :edit, :update]
  
  cache_sweeper :codes_sweeper, :only => [:create, :update, :destroy]
  
  def index
    redirect_to home_url
  end

  def show
    @code = Code.find(params[:id], :include => :refactors)
    
    serializer_options = { :include => :refactors, :except => [:user_email, :signature, :spam, :spaminess] }
    
    respond_to do |format|
      format.html
      format.xml  { render :xml => @code.to_xml(serializer_options) }
    end
  end

  def new
    @code = Code.new
  end

  def edit
  end

  def create
    @code = Code.new(params[:code])
    @code.user = self.current_user

    if @code.save
      redirect_to code_url(@code)
    else
      render :action => "new"
    end
  end

  def update
    if @code.update_attributes(params[:code])
      flash[:notice] = 'Info updated'
      redirect_to code_url(@code)
    else
      render :action => "edit"
    end
  end
  
  def pastable
  end

  def destroy
    @code.destroy

    redirect_to home_url
  end
  
  def follow
    if current_user.email.blank?
      @error = "You need to specify your email in your account to do this"
    else
      Notification.create :code => @code, :user => current_user,
                          :name => current_user.name, :email => current_user.email unless Notification.find_by_code_id_and_email(@code.id, current_user.email)
    end
    
    respond_to do |format|
      format.js
    end
  end
  
  private
    def find_code
      @code = Code.find(params[:id])
    end
    
    def find_tags
      @tags = Tag.find(:all, :order => 'name')
    end
end
