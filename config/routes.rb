Rails.application.routes.draw do
  devise_for :users
  root to: "pages#home"

  resources :cars do
    get :listmycars, on: :collection
  end

  resources :bookings, except: [:destroy, :new] do
    resources :reviews, only: [:new, :create]
    patch :approve, on: :member
    # approve_booking PATCH  /bookings/:id/approve   bookings#approve
    patch :decline, on: :member
    # decline_booking PATCH  /bookings/:id/decline   bookings#decline
    patch :cancel, on: :member
  end

  resources :reviews, only: :destroy

  namespace :chat do
    resources :bookings, only: [:show] do
    # chat_booking  GET  /chat/bookings/:id    chat/bookings#show
      resources :messages, only: :create
      # chat_booking_messages  POST  /chat/bookings/:booking_id/messages  chat/messages#create
    end
  end
end

  # resources :chatrooms, only: :show do
  #   resources :messages, only: :create
  # end

  # patch '/booking/:id', to: 'bookings#modify', as: :modify_booking
  # get "cars/search", to: "cars#search"
  # get "/users", to: redirect("/404")

