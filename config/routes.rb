Rails.application.routes.draw do
  mount ForestLiana::Engine => '/forest'
  root to: "players#new"
  resources :players, except: [:new]

  match "/404", to: "errors#not_found", via: :all
  match "/500", to: "errors#internal_server_error", via: :all
end
