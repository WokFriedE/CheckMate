Rails.application.routes.draw do
  root "application#index"

  get  "signup", to: "authentication#signup_form"
  post "signup", to: "authentication#signup"

  get  "login", to: "authentication#login_form"
  post "login", to: "authentication#login"

  delete "logout", to: "authentication#logout"

  get "landing", to: "landing#index"
end
