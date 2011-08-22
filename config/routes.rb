SakaiWidgetlibrary::Application.routes.draw do

  devise_for :users, :controllers => {:sessions => 'sessions'}, :skip => [:sessions] do
    post "/login" => "sessions#create", :as => :user_session
    get "/logout" => "devise/sessions#destroy", :as => :logout
    get "/register" => "devise/registrations#new", :as => :user_registration
    post "/register" => "devise/registrations#create", :as => :user_registration
    get "/register" => "devise/registrations#new", :as => :new_user_registration
    get "/forgot_password" => "devise/passwords#new", :as => :new_user_password
  end

  match '/widget/:widget_title' => 'widget#show', :as => :widget
  match '/browse' => 'browse#index', :as => :browse
  match '/developer' => 'developer#index', :as => :developer
  match '/developer/widgetbuilder' => 'developer#widgetbuilder'
  match '/developer/:developer_name' => 'developerdetails#index', :as => :developer_page
  match '/mywidgets' => 'mywidgets#index', :as => :mywidgets
  match 'submit' => 'submit#index'
  match '/zippedwidget' => 'widget_generator#zippedwidget'
  root :to => "home#index"

end
