ActionController::Routing::Routes.draw do |map|
  # Backward compatibility w/ 1.2 Routes
  map.connect 'badges/:id.gif;position', :controller => 'badges', :action => 'position', :format => 'gif'
  
  
  map.with_options :controller => 'browse', :conditions => { :method => :get } do |browse|
    def browse.section(action, path)
      languageless_path = path.sub('/:language', '')
      
      self.named_route action, "#{path}/:page", :action => action.to_s, :language => 'all',
                                                :page => 1, :requirements => { :page => /\d+/ }
      self.connect "#{languageless_path}.:format", :action => action.to_s # For backward compatibility
      self.connect "#{path}.:format", :action => action.to_s
    end
    
    browse.section :recent_codes, 'codes/recent/:language'
    browse.section :popular_codes, 'codes/popular/:language'
    browse.section :recent_refactors, 'refactorings/recent/:language'

    browse.best_refactorers 'refactorers/best/:page', :action => 'best_refactorers',
                            :page => 1, :requirements => { :page => /\d+/ }

    browse.section :tags, 'tags/:tags/:language'

    browse.home '', :action => 'recent_codes'  
  end
  
  map.resources :users do |users|
    users.resource :friends
  end
  map.resources :badges, :member => { :position => :get }
  
  # HACK the custom action create is required here because of caching.
  # Seems like Apache will forward even POST request to the HTML file if it exists.
  map.resources :codes, :collection => { :create => :post }, :member => { :pastable => :get, :follow => :post } do |codes|
    codes.resources :refactors, :name_prefix => nil, :member => { :rate => :post, :mark_as_spam => :post, :mark_as_ham => :post }
  end
  
  map.spam 'spam', :controller => 'refactors', :conditions => { :method => :get }
  map.destroy_all_spam 'spam', :controller => 'refactors', :action => 'destroy_all_spam', :conditions => { :method => :delete }
  map.search 'search', :controller => 'browse', :action => 'search', :conditions => { :method => :get }
    
  map.with_options :controller => 'sessions' do |session|
    session.login            'login',   :action => 'new'
    session.logout           'logout',  :action => 'destroy'
    session.open_id_complete 'session', :action => 'create',
                                        :requirements => { :method => :get }
  end
  
  map.resource :session, :account
  
  map.with_options :controller => 'help' do |help|
    help.code_help 'help/code', :action => 'code'
    help.api_help  'help/api',  :action => 'api'
  end
end
