Rails.application.routes.draw do
  get '/', to: 'search#index'
  get 'search', to: 'search#search'
  get 'analytics', to: 'search#analytics'
  get 'regUpdates', to: 'search#save_cached_data_to_database'
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
end
