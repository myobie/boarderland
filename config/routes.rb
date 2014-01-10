Boarderland::Application.routes.draw do
  get 'authorize/wunderlist' => 'wunderlist#authorize', as: :authorize_wunderlist
  get 'callback/wunderlist' => 'wunderlist#callback'

  resources :lists do
    collection do
      post :add
    end
  end

  root "lists#index"
end
