Rails.application.routes.draw do
  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"

  post '/users/priv_f' => 'users#priv_f'
  post '/users/priv_p' => 'users#priv_p'
  get '/users/:id/public' => 'users#public_show'
  get '/events/newest_event' => 'events#newest_event'
  get '/events/index_ajax' => 'events#index_ajax'
  get '/events/tiles' => 'events#index_tiles'
  post '/users/ajax_join_event/:id' => 'users#ajax_join_event'
  root 'users#new'
  get '/users/:id/interests' => 'users#interests'
  get '/users/:id/allinterests' => 'users#allinterests'
  get '/users/logout' => 'users#logout'
  post '/users/interests_handler' => 'users#interests_handler'
  post '/users/activity_dislikes_handler' => 'users#activity_dislikes_handler'
  post '/users/mile_preference_handler' => 'users#mile_preference_handler'
  get '/users/:id' => 'users#show'
  resources :users
  resources :activities, :only => [:new, :create]
  resources :events do
    resources :comments
  end
end
