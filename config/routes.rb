Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  root "info#reglas"
  resources :clases
  resources :habilidads
  resources :items
  resources :pictures
  resources :mobs
  resources :categs
  resources :estadoalterados
  resources :dndspells
  resources :etiquets
  resources :images do
    member do
      get 'download'
    end
  end
  resource :adminsession, only: [:new, :create]
  get '/adminsession/close', to: 'adminsessions#close'
  get '/reglas', to: 'info#reglas'
  get '/estadosAlterados', to: 'info#estadosAlterados'
  get '/lore', to: 'info#lore'
  get '/avisolegal', to: 'info#avisolegal'
  get '/control', to: 'admin#control'
  get '/items_no_categ', to: 'admin#items_no_categ'
  get '/habilidads_ocultas', to: 'admin#habilidads_ocultas'
  get '/habilidads_sueltas', to: 'admin#habilidads_sueltas'
  get '/delete_disk_cache', to: 'admin#delete_disk_cache'
  get '/lootbox', to: 'randompick#lootbox'
  post '/lootboxing', to: 'randompick#lootboxing'
  get '/clases-arbol', to: 'info#arbol'
  get '/resetdndspells', to: 'dndspells#reset'
end
