Rails.application.routes.draw do
  mount ForestLiana::Engine => '/forest'
  root to: "players#new"
  resources :players, except: [:new]
  delete "/destroy", to: "players#destroy_counter", as: :sessions
  match "/404", to: "errors#not_found", via: :all
  match "/500", to: "errors#internal_server_error", via: :all
end
