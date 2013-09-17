Alpaca::Application.routes.draw do

  match '/signout' => 'sessions#destroy', :as => :signout

  match '/signin' => 'sessions#new', :as => :signin

  root :to => 'home#index'
  
  match '/privacy' => 'home#privacy'
  
  match '/terms' => 'home#terms'
  
  match '/users/account' => 'users#account', :as => :account
  
  resources :profiles, :only => [:show, :new, :create] do
      resources :comments, :only => [:create, :update, :destroy]
      resource :ratings, :only => [:create, :update, :destroy]
    end


  scope '(:locale)', :locale => /en|th|zh_tw|zh_cn/, :as => "localized" do

    match '/favs' => 'favorites#index'
    match '/profiles/:profile_id/fav' => 'favorites#create'
    match '/profiles/:profile_id/unfav' => 'favorites#destroy'
    match '/profiles/:profile_id/vote' => 'votes#create', :via => :post
    match '/profiles/:profile_id/unvote' => 'votes#destroy' #, :via => :post

    match '/auth/:provider/callback' => 'sessions#create'

    match '/signout' => 'sessions#destroy', :as => :signout

    match '/signin' => 'sessions#new', :as => :signin

    # get '/users/account'

    match '/users/account' => 'users#account', :as => :account

    match '/auth/failure' => redirect('/')

    put '/users/:id' => 'users#update'

    match '/users/:id/showfriendslist' => 'users#showFriendsList'

    match '/users/:id/showfriendskeys' => 'users#showFriendsKeys'

    match '/users/:id/getGender' => 'users#getGender'

    match '/users/:id/filterfriends' => 'users#filterFriends'

    match '/profiles/:id/getRatings' => 'profiles#getRatings'

    match '/profiles/show_profile/:fbid' => 'profiles#show_profile'

    get 'home/index'

    match '/home' => 'home#index'

    root :to => 'home#index'

    

    resources :users, :only => [:show, :create]

  end

  resources :users, :only => [:show, :create]
  resources :favorites
  resources :votes

end

