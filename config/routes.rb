Rails.application.routes.draw do
  # namespace :api do
  #   resources :languages
  # end
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  #

  get '/languages', to: 'api/languages#index'

end
