class RefactorsController < ApplicationController
  before_filter :login_required,          :only   => [:rate]
  before_filter :admin_required,          :only   => [:index, :mark_as_ham, :destroy_all_spam]
  before_filter :find_code,               :except => [:index, :destroy_all_spam]
  before_filter :find_refactor,           :only   => [:show, :edit, :update, :destroy, :rate, :mark_as_spam, :mark_as_ham]
  before_filter :author_of_code_required, :only   => [:destroy, :mark_as_spam]
  before_filter :author_of_refactor_required, :only => [:edit, :update]
  before_filter :find_stats,              :only   => [:index, :mark_as_spam, :mark_as_ham]
  
  cache_sweeper :codes_sweeper, :except => [:index, :show, :destroy_all_spam]
  
  # TODO move this to BrowseController#spam ?
  def index
    @refactors = Refactor.where("spam = '1'").order("spaminess DESC").page(params[:page]).per(25)
  end
  
  def show
    respond_to do |format|
      format.html { redirect_to code_url(@code) + "\#refactor_#{@refactor.id}" }
      format.js
    end
  end
  
  def create
    @refactor = @code.refactors.build(params[:refactor])
    if logged_in?
      @refactor.user         = self.current_user
      @refactor.user_name    = current_user.name
      @refactor.user_email   = current_user.email
      @refactor.user_website = current_user.website
    end
    @refactor.env      = request.env
    @refactor.language = @code.language
    
    if @refactor.save
      send_trackback @refactor unless @refactor.spam
    end
    
    respond_to do |format|
      format.js
    end
  end
  
  def edit
    respond_to do |format|
      format.js
    end
  end
  
  def update
    @success = @refactor.update_attributes(params[:refactor])
    respond_to do |format|
      format.js
    end
  end
  
  def destroy
    @refactor.destroy
    
    respond_to do |format|
      format.js
    end
  end
    
  def rate
    @rating = @refactor.ratings.build(:value => params[:rating])
    @rating.user = current_user
    
    if @rating.save
      @refactor.reload
    end
    
    respond_to do |format|
      format.js
    end
  end
  
  def destroy_all_spam
    Refactor.destroy_all 'spam = 1'
    
    redirect_to spam_path
  end
  
  def mark_as_spam
    @refactor.report_as_spam
    
    respond_to do |format|
      format.js { render :action => 'destroy' }
    end
  end
  
  def mark_as_ham
    @refactor.report_as_ham
    
    respond_to do |format|
      format.js
    end
  end
  
  protected    
    def author_of_refactor_required
      return true if author_of_refactor?(@refactor)
      flash[:notice] = "Only the author can do this"
      redirect_to code_path(@code)
      false
    end
    
  private
    def find_code
      @code = Code.find(params[:code_id])
    end
    
    def find_refactor
      @refactor = Refactor.find_by_code_id_and_id(params[:code_id], params[:id])
    end
    
    def find_stats
      @stats = Refactor.defensio_stats
    rescue Defensio::Error
      @stats = nil
    end
    
    # See trackback specs:
    #   http://www.sixapart.com/pronet/docs/trackback_spec
    def send_trackback(refactor)
      code = refactor.refactored_code
      return if code.trackback_url.blank?
      logger.info "[TRACKBACK] Sending trackback to #{code.trackback_url}"
      Net::HTTP.post_form URI.parse(code.trackback_url), :url       => refactor_url(code, refactor),
                                                         :excerpt   => refactor.comment,
                                                         :title     => code.title,
                                                         :blog_name => "#{refactor.user_name} on RefactorMyCode.com"
    rescue Exception => e
      logger.error "[TRACKBACK] ERROR: Unable to send trackback to #{code.trackback_url} : #{e.message}"
    end
end