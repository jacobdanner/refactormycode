class HelpController < ApplicationController
  caches_page :code, :api
  
  def code
    @languages = CodeFormatter.languages
    @syntaxes = CodeFormatter.syntaxes
  end
  
  def api
    
  end
end
