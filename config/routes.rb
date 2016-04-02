Rails.application.routes.draw do
  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"

#Begin Ian's broken restfulness:
post '/users/ajax_join_event/:id' => 'users#ajax_join_event'
#End of the atrocity

  root 'users#new'

  get '/users/logout' => 'users#logout'
  get '/users/:id' => 'users#show'
  resources :users
  resources :events


end
