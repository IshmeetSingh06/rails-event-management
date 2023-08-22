Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"

      post '/users/register', to: 'users#create'
      post '/users/login', to: 'users#login'

end
