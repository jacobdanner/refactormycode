RefactorMyCode::Application.routes.draw do
  
  root :to => "browse#recent_codes"
  match "/", :to => "browse#recent_codes", :as => :home
  match "search", :to => "browse#search", :as => :search
  
  match "login", :to => "sessions#new", :as => :login
  match "logout", :to => "sessions#destroy", :as => :logout
  
  
  resources "browse" do
    collection do
      get "recent_codes"
      get "best_refactorers"
      get "search"
    end
  end
  
  match 'refactorers/best/(:page)', :to => 'browse#best_refactorers', :as => :best_refactorers
  
  resources "refactors" do
    collection do
      get "recent"
      get "best"
    end
  end
  
  resources "codes" do
    collection do
       get "popular"
    end
  end
  
  resources "sessions", "accounts", "badges", "friends", "users", "help", "tags"
end
