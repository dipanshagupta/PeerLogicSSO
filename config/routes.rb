Rails.application.routes.draw do
	
  get    '/login',   to: 'sessions#new'
  post   '/login',   to: 'sessions#create'
  delete '/logout',  to: 'sessions#destroy'
  get '/clients/requestKey', to:'clients#requestKey'
  get '/clients/generateKey', to:'clients#generateKey'
  get '/clients/revokeKey', to:'clients#revokeKey'
  get '/clients/enableApisForm', to:'clients#enableApisForm'

  post '/clients/enableApisForm', to:'clients#enableApis'
  get '/token/get', to: 'tokens#getToken'
  post '/token/validate', to: 'tokens#validateToken'

	resources :users
	resources :apis
	resources :clients, :except => :show


  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
