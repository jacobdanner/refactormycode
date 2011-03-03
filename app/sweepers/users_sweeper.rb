class UsersSweeper < ActionController::Caching::Sweeper
  include CachingExtensions::Sweeping
  observe User

  def after_save(user)
    expire_browser_pages
    
    expire_fragment :controller => 'users', :action => 'show', :id => user
    expire_pages "users/#{user.id}.*"
    user.refactors.each do |refactor|
      expire_fragment :controller => 'refactors', :action => 'show',
                      :code_id => refactor.refactored_code, :id => refactor
    end
  end
  
  alias_method :after_destroy, :after_save
end