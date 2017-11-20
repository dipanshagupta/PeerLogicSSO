Rails.application.routes.draw do
	
  get    '/login',   to: 'sessions#new'
  post   '/login',   to: 'sessions#create'
  delete '/logout',  to: 'sessions#destroy'
  get '/clients/requestKey', to:'clients#requestKey'

	resources :users
	resources :apis
	resources :clients, :except => :show


  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end