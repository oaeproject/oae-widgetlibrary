SakaiWidgetlibrary::Application.routes.draw do

  devise_for :users, :controllers => {:sessions => 'sessions'}, :skip => [:sessions] do
    post '/login' => 'sessions#create', :as => :user_session
    get '/logout' => 'devise/sessions#destroy', :as => :logout
    get '/register' => 'devise/registrations#new', :as => :user_registration
    post '/register' => 'registrations#create', :as => :user_registration
    get '/register' => 'devise/registrations#new', :as => :new_user_registration
    get '/register/check_username/:username' => 'registrations#check_username'
    get '/forgot_password' => 'devise/passwords#new', :as => :new_user_password
  end

  match '/widget/:widget_title' => 'widget#show', :as => :widget

  match '/browse' => 'browse#index', :as => :browse
  match '/browse/:category_title' => 'browse#index', :as => :category

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

  match '/developer/:developer_name' => 'developerdetails#index', :as => :developer_page

  match '/mywidgets' => 'mywidgets#index', :as => :mywidgets
  match '/mywidgets/:filter' => 'mywidgets#index'

  get '/submit' => 'submit#index'
  post '/submit' => 'submit#create', :as => :create_widget
  get '/edit/:widget_id' => 'submit#edit', :as => :edit_widget
  post '/edit/:widget_id' => 'submit#new_version', :as => :new_widget_version

  match '/search' => 'application#search'

  match '/zippedwidget' => 'widget_generator#zippedwidget'

  match '/admin/users' => 'admin#users', :as => :admin_users
  match '/admin/users/admin' => 'admin#users', :as => :admin_admin_users
  match '/admin/options' => 'admin#options', :as => :admin_options
  match '/admin' => 'admin#widgets'
  match '/admin/widgets' => 'admin#widgets', :as => :admin
  match '/admin/widgets/:filter' => 'admin#widgets'
  match '/admin/widgets/:method/:widget_id' => 'admin#reviewed'

  root :to => 'home#index'

end
