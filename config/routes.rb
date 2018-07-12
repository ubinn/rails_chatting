Rails.application.routes.draw do
  root 'chat_rooms#index'
  resources :chat_rooms
  devise_for :users
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  
  resources :chat_rooms do
    member do
      post'/join' => 'chat_rooms#user_admit_room', as: 'join'
      post'/chat' => 'chat_rooms#chat'
      delete '/exit' => 'chat_rooms#user_exit_room'
      post '/ready' => 'chat_rooms#is_user_ready'
    end
  end
  
end
