Rails.application.routes.draw do
  resources :cuentos
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  root "info#home"
  resources :clases
  resources :habilidads
  resources :items
  resources :pictures
  resources :mobs
  resources :categs
  resources :estadoalterados
  resources :dndspells
  resources :etiquets
  resources :cuentos
  get '/recalcular_childs', to: 'cuentos#recalcular_childs'

  get 'images/:id/download', to: 'images#download', as: 'download_image'
  
  resource :adminsession, only: [:new, :create]
  get '/adminsession/close', to: 'adminsessions#close'

  get '/reglas', to: 'info#reglas'
  get '/estadosAlterados', to: 'info#estadosAlterados'
  get '/avisolegal', to: 'info#avisolegal'
  get '/clases-arbol', to: 'info#arbol'
  get '/get_random_element', to: 'info#get_random_element'

  get '/control', to: 'admin#control'
  get '/items_no_categ', to: 'admin#items_no_categ'
  get '/habilidads_ocultas', to: 'admin#habilidads_ocultas'
  get '/habilidads_sueltas', to: 'admin#habilidads_sueltas'
  get '/delete_disk_cache', to: 'admin#delete_disk_cache'
  get '/delete_navbar_cache', to: 'admin#delete_navbar_cache'
  get '/delete_all_cache', to: 'admin#delete_all_cache'
  get '/backup', to: 'admin#backup'
  get '/create_backup', to: 'admin#create_backup'
  post '/restore_backup', to: 'admin#restore_backup'

  get '/lootbox', to: 'randompick#lootbox'
  post '/lootboxing', to: 'randompick#lootboxing'
  get '/resetdndspells', to: 'dndspells#reset'
  get '/clasificar_habilidad', to: 'habilidads#clasificar'
end
