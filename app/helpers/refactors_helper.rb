module RefactorsHelper
  def link_to_user(refactor)
    if refactor.user
      link_to h(refactor.user_name), user_path(refactor.user)
    else
      link_to_unless refactor.user_website.blank?, h(refactor.user_name), linkify(refactor.user_website)
    end
  end
  
  def rated?(refactor)
    @rating || (logged_in? && current_user.rated?(refactor))
  end
  
  def owner?(refactor)
    logged_in? && refactor.user == self.current_user
  end
  
  def refactor_cache_key(refactor)
    { :controller => 'refactors', :action => 'show', :code_id => refactor.refactored_code, :id => refactor }
  end
  
  def code_refactor_path(refactor)
    code_path(refactor.refactored_code) + "\#refactor_#{refactor.id}"
  end
  
  def code_refactor_url(refactor)
    code_url(refactor.refactored_code) + "\#refactor_#{refactor.id}"
  end
end
