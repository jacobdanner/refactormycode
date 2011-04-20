RefactorMyCode::Application.routes.draw do
  
  root :to => "browse#recent_codes"
  match "/", :to => "browse#recent_codes", :as => :home
  match "search", :to => "browse#search", :as => :search
  
  match "login", :to => "sessions#new", :as => :login
  match "logout", :to => "sessions#destroy", :as => :logout
  
  match "spam", :to => "refactors#index", :as => :spam
  match "api/help", :to => "help#api", :as => :api_help
  match "code/help", :to => "help#code", :as => :code_help
  
  match 'refactorers/best/(:page)', :to => 'browse#best_refactorers', :as => :best_refactorers
  match "tags/:tags/(:language)", :to => "browse#tags", :as => :tags
  
  post 'spam', :to => 'refactors#destroy_all_spam', :as => :destroy_all_spam
  
  resources "browse" do
    collection do
      get "recent_codes"
      get "popular_codes"
      get "best_refactorers"
      get "recent_refactors"
      get "search"
    end
  end
  
  resources "codes" do
    member do
      get "follow"
      get "pastable"
    end
  end
  
  resources "refactors" do
    member do
      post "mark_as_spam"
      post "rate"
    end
  end
  
  resources "users" do
    resources "friend"
  end
  
  resources "sessions", "accounts", "badges","help"
  
  resource :session, :account
  
  match '/auth/:service/callback' => 'authentications#create' 
  resources :authentications, :only => [:index, :create, :destroy]
  
end
