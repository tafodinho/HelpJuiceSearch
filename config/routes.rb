Rails.application.routes.draw do
  get '/', to: 'search#index'
  get 'search', to: 'search#search'
  get 'analytics', to: 'search#analytics'
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
end
