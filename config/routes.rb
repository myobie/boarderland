Boarderland::Application.routes.draw do
  get "timeline" => 'timeline#index'
  get "boards" => 'board#index'
  get 'authorize/wunderlist' => 'wunderlist#authorize', as: :authorize_wunderlist
  get 'callback/wunderlist' => 'wunderlist#callback'

  resources :lists do
    collection do
      post :add
    end
    member do
      get :by_wunderlist_id
    end
  end

  root "lists#index"
end
