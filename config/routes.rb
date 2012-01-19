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
  match '/browse' => 'browse#index', :as => :browse
  match '/browse/:category_title' => 'browse#index', :as => :category

  # Widget Details
  match '/widget/:title' => 'widget#show', :as => :widget
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
  match '/sdk/developwidget' => 'sdk#developwidget'
  match '/sdk/developwidget/learnbasics' => 'sdk#learnbasics'
  match '/sdk/developwidget/codingstandards' => 'sdk#codingstandards'
  match '/sdk/developwidget/quickdevsetup' => 'sdk#quickdevsetup'
  match '/sdk/developwidget/fulldevsetup' => 'sdk#fulldevsetup'
  match '/sdk/developwidget/widgetbuilder' => 'sdk#widgetbuilder'
  match '/sdk/examples' => 'sdk#examples'
  match '/sdk/examples/worlddashboard' => 'sdk#worlddashboard'
  match '/sdk/examples/pagewidget' => 'sdk#pagewidget'
  match '/sdk/widgetdesignandstyle' => 'sdk#widgetdesignandstyle'
  match '/sdk/widgetdesignandstyle/cssguide' => 'sdk#cssguide'
  match '/sdk/widgetdesignandstyle/reusablecss' => 'sdk#reusablecss'
  match '/sdk/widgetdesignandstyle/typography' => 'sdk#typography'
  match '/sdk/widgetdesignandstyle/colorpalette' => 'sdk#colorpalette'
  match '/sdk/widgetdesignandstyle/widgetexamples01' => 'sdk#widgetexamples01'
  match '/sdk/widgetdesignandstyle/widgetexamples02' => 'sdk#widgetexamples02'
  match '/sdk/widgetdesignandstyle/forms' => 'sdk#forms'
  match '/sdk/widgetdesignandstyle/navigationalitems' => 'sdk#navigationalitems'
  match '/sdk/widgetdesignandstyle/iconography' => 'sdk#iconography'
  match '/sdk/widgetdesignandstyle/interactionmodels' => 'sdk#interactionmodels'
  match '/sdk/services/frontend' => 'sdk#frontend'
  match '/sdk/services/backend' => 'sdk#backend'
  match '/sdk/services/thirdparty' => 'sdk#thirdparty'
  match '/sdk/faq' => 'sdk#faq'
  match '/sdk/help' => 'sdk#help'
  match '/zippedwidget' => 'widget_generator#zippedwidget'


  # Admin section
  match '/admin/users' => 'admin#users', :as => :admin_users
  match '/admin/users/admin' => 'admin#users', :as => :admin_admin_users
  match '/admin/options' => 'admin#options', :as => :admin_options
  match '/admin' => 'admin#widgets'
  match '/admin/widgets' => 'admin#widgets', :as => :admin
  match '/admin/widgets/:state' => 'admin#widgets', :as => :admin_state
  match '/admin/widgets/:review/:version_id' => 'admin#reviewed', :as => :admin_review_widget

  # Errors
  unless Rails.application.config.consider_all_requests_local
    match '*not_found', to: 'errors#e404'
  end
  get "errors/e404"
  get "errors/e500"

  root :to => 'home#index'

end
