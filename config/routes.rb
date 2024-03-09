Rails.application.routes.draw do
  root "billets#index"
  resources :billets
  mount GoodJob::Engine, at: "good_job"
  get "up" => "rails/health#show", as: :rails_health_check
end
