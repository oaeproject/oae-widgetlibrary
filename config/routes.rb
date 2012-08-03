SakaiWidgetlibrary::Application.routes.draw do

  # Routes for devise authentication
  devise_for :users, :controllers => {:sessions => 'sessions'}, :skip => [:sessions] do
    get  '/' => "home#index", :as => :new_user_session
    post '/login' => 'sessions#create', :as => :user_session
    get  '/logout' => 'devise/sessions#destroy', :as => :logout
    get  '/register' => 'devise/registrations#new', :as => :user_registration
    post '/register' => 'registrations#create', :as => :user_registration
    get  '/register' => 'devise/registrations#new', :as => :new_user_registration
    get  '/register/check_username/:username' => 'registrations#check_username'
    get  '/forgot_password' => 'devise/passwords#new', :as => :new_user_password
    post '/forgot_password' => 'passwords#create', :as => :user_password
    put  '/forgot_password' => 'passwords#update', :as => :user_password
    put  '/register' => 'registrations#update', :as => :edit_user_registration
    get  '/edit' => 'devise/registrations#edit', :as => :edit_user_registration
  end

  # Application-level routes
  match '/search' => 'application#search'

  # Browse
  match '/browse(/:category_title)' => 'browse#index', :as => :browse

  # Widget Details
  get   '/widget/:title' => 'widget#show', :as => :widget
  post  '/widget/:title/rate' => 'widget#rating_create', :as => :ratings
  put   '/widget/:title/rate' => 'widget#rating_update', :as => :ratings

  # Widget code (hijacking paperclip's route)
  get   '/widget/:title/:version/download' => "widget#download", :as => :widget_download
  get   '/widget/:title/:version/backend/download' => "widget#download_backend", :as => :widget_download_backend

  # Widget Submission (Versions)
  resources :versions, :path => "submit", :controller => "submit"

  # Users
  get '/user/:id-:url_title' => 'user#index', :as => :user

  # My Widgets
  match '/mywidgets' => 'mywidgets#index', :as => :mywidgets
  match '/mywidgets/submissions' => 'mywidgets#submissions', :as => :mywidgets_submissions

  # SDK
  match '/sdk' => 'sdk#index', :as => :sdk
  match '/sdk/*section' => 'sdk#sdk_section'
  match '/zippedwidget' => 'widget_generator#zippedwidget'


  # Admin section
  match '/admin/users' => 'admin#users', :as => :admin_users
  match '/admin/users/admin' => 'admin#adminusers', :as => :admin_admin_users
  match '/admin/options' => 'admin#options', :as => :admin_options
  match '/admin/languages/edit/:id' => 'admin#edit_language', :as => :admin_edit_language
  post  '/admin/languages/save' => 'admin#save_language', :as => :admin_add_edit_language
  delete  '/admin/languages/remove/:id' => 'admin#remove_language', :as => :admin_remove_language
  match '/admin/categories' => 'admin#categories', :as => :admin_categories
  match '/admin/categories/edit/:id' => 'admin#edit_category', :as => :admin_edit_category
  post  '/admin/categories/save' => 'admin#save_category', :as => :admin_add_edit_category
  delete '/admin/categories/remove/:id' => 'admin#remove_category', :as => :admin_remove_category
  match '/admin/statistics' => 'admin#statistics', :as => :admin_statistics
  match '/admin' => 'admin#widgets'
  match '/admin/widgets(/:state)' => 'admin#widgets', :as => :admin
  match '/admin/widgets/:review/:version_id' => 'admin#reviewed', :as => :admin_review_widget
  post  '/admin/users/update' => 'admin#user_update', :as => :update

  # Errors
  unless Rails.application.config.consider_all_requests_local
    match '*not_found', to: 'errors#e404'
  end
  get "errors/e404"
  get "errors/e500"

  root :to => 'home#index'

end
