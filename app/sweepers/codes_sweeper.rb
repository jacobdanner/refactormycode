class CodesSweeper < ActionController::Caching::Sweeper
  include CachingExtensions::Sweeping
  observe Code, Refactor

  def after_save(record)
    # Do not expire cache on spam!
    return if record.class == Refactor && record.spam
    
    expire_browser_pages
    
    expire_fragment 'sidebar'
    
    code = case record
    when Code
      record
    when Refactor
      expire_fragment :controller => 'refactors', :action => 'show', :code_id => record.refactored_code, :id => record
      expire_fragment :controller => 'codes', :action => 'show', :code_id => record.refactored_code, :id => record
      record.refactored_code
    end
    
    expire_fragment :controller => 'codes', :action => 'show', :id => code
    
    if record.user
      expire_all_fragments 'users/*'
      expire_all_fragments 'badges/*'
    end
  end
  
  alias_method :after_destroy, :after_save
end