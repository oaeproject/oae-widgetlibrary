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

  match '/developer' => 'developer#index', :as => :developer
  match '/developer/developwidget' => 'developer#developwidget'
  match '/developer/developwidget/learnbasics' => 'developer#learnbasics'
  match '/developer/developwidget/codingstandards' => 'developer#codingstandards'
  match '/developer/developwidget/quickdevsetup' => 'developer#quickdevsetup'
  match '/developer/developwidget/fulldevsetup' => 'developer#fulldevsetup'
  match '/developer/developwidget/widgetbuilder' => 'developer#widgetbuilder'
  match '/developer/examples' => 'developer#examples'
  match '/developer/examples/worlddashboard' => 'developer#worlddashboard'
  match '/developer/examples/pagewidget' => 'developer#pagewidget'
  match '/developer/widgetdesignandstyle' => 'developer#widgetdesignandstyle'
  match '/developer/widgetdesignandstyle/typography' => 'developer#typography'
  match '/developer/widgetdesignandstyle/colorpalette' => 'developer#colorpalette'
  match '/developer/widgetdesignandstyle/widgetexamples01' => 'developer#widgetexamples01'
  match '/developer/widgetdesignandstyle/widgetexamples02' => 'developer#widgetexamples02'
  match '/developer/widgetdesignandstyle/forms' => 'developer#forms'
  match '/developer/widgetdesignandstyle/navigationalitems' => 'developer#navigationalitems'
  match '/developer/widgetdesignandstyle/iconography' => 'developer#iconography'
  match '/developer/widgetdesignandstyle/interactionmodels' => 'developer#interactionmodels'
  match '/developer/services/frontend' => 'developer#frontend'
  match '/developer/services/backend' => 'developer#backend'
  match '/developer/services/thirdparty' => 'developer#thirdparty'
  match '/developer/faq' => 'developer#faq'
  match '/developer/help' => 'developer#help'

  match '/developer/:developer_name' => 'developerdetails#index', :as => :developer_page

  match '/mywidgets' => 'mywidgets#index', :as => :mywidgets

  match '/submit' => 'submit#index'

  match '/search' => "application#search"

  match '/zippedwidget' => 'widget_generator#zippedwidget'
  root :to => "home#index"

end
