Rails.application.routes.draw do
  resources :page_views, only: %i(index)
  resources :spa, only: %i(index)

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
