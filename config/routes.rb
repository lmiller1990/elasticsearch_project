Rails.application.routes.draw do
  resources :elastic_search, only: %i(index)

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
