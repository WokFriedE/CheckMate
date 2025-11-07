Rails.application.routes.draw do
  root "application#index"

  get  "signup", to: "authentication#signup_form"
  post "signup", to: "authentication#signup"

  get  "login", to: "authentication#login_form"
  post "login", to: "authentication#login"

  delete "logout", to: "authentication#logout"

  get "landing", to: "landing#index"

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

end
