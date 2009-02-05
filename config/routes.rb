ActionController::Routing::Routes.draw do |map|

  map.resources :architects
  map.resources :theaters
  map.connect ':controller/:action/:id'
  map.connect ':controller/:action/:id.:format'

end
