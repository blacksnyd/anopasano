Rails.application.routes.draw do
  root to: "players#new"
  resources :players, except: [:new]
end
