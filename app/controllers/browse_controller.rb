class BrowseController < ApplicationController  
  caches_page :recent_codes, :popular_codes, :recent_refactors, :best_refactorers, :tags
  [:atom, :xml].each do |format|
    cache_formatted_page format, :popular_codes, :recent_refactors, :best_refactorers, :recent_codes, :tags
  end
  
  PER_PAGE = 25
  
  def recent_codes
    browse :codes, :title => "Recent #{language_title} codes",
                   :order => 'created_at desc',
                   :conditions => language_conditions
  end
  
  def popular_codes
    browse :codes, :title => "Popular #{language_title} codes",
                   :order => Code.popular_sql_order,
                   :conditions => language_conditions
  end
  
  def recent_refactors
    browse :refactors, :title => "Recent #{language_title} refactorings",
                       :order => 'refactors.created_at desc',
                       :conditions => language_conditions('refactors.spam = false')
  end
  
  def best_refactorers
    browse :users, :title => 'Best refactorers',
                   :order => 'rating desc, refactors_count desc',
                   :feed => false
  end
  
  def tags
    @tags = params[:name]
    browse :codes,   :title => "Codes tagged with #{@tags}",
                     :order => 'created_at desc',
                     :conditions => language_conditions
                   
                   
  end
  
  def search
    # TODO fix ferret
    raise ActiveRecord::RecordNotFound
    
    @query = params[:q]
    if @query.blank?
      flash[:notice] = "Type something if you'd like to search that something"
      redirect_to home_path
    else
      page = (params[:page] || 1).to_i
      results = Code.search(@query, :limit => PER_PAGE, :offset => PER_PAGE * (page-1))
      @items = WillPaginate::Collection.new(page, PER_PAGE, results.total_hits)
      @items.replace results
    end
  end
    
  private
    def language?
      !params[:language].blank? && params[:language] != 'all'
    end
  
    def language_title
      ' ' + CodeFormatter.unescape_language(params[:language]) if language?
    end
  
    def language_conditions(extra_conditions=nil)
      if language?
        ["codes.language = ? #{'AND ' + extra_conditions if extra_conditions}",
          CodeFormatter.unescape_language(params[:language])]
      else
        extra_conditions
      end
    end
  
    def browse(model, options={})
      @title      = options.delete(:title) || raise(':title required')
      @feed       = options.has_key?(:feed) ? options.delete(:feed) : true
      @plural     = model.to_s
      @singular   = model.to_s.singularize
      model_class = model.to_s.classify.constantize
      page        = params[:page].to_i
      page        = 1 if page == 0

      # records = model_class.papaginate({ :per_page => PER_PAGE, :page => page }.merge(options))
      unless @tags.blank?
        @items = Code.tagged_with(@tags, :any => true).where(options[:conditions]).order(options[:order]).page(page).per(PER_PAGE)
      end
      @items ||= model_class.where(options[:conditions]).order(options[:order]).page(page).per(PER_PAGE)
      # @items  = records
      instance_variable_set :"@#{@plural}", @items
      
      serializer_options = { :include => :user,
                             :except => [:user_email, :signature, :spam, :spaminess,
                                         :admin, :email, :token, :alternative_identity_url] }
      
      respond_to do |format|
        format.html { render :action => 'items' }
        format.atom { render :action => @plural, :layout => false }
        format.xml  { render :xml    => @items.to_xml(serializer_options) }
      end
    end
end
