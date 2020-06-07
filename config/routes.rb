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
  # patch '/booking/:id', to: 'bookings#modify', as: :modify_booking
  # get "cars/search", to: "cars#search"
  # get "/users", to: redirect("/404")
end


# BELOW ROUTES GENERATED:
# GET    /                 cars#index
# GET    /cars/listmycars  cars#listmycars
# GET    /cars/search      cars#search
# POST   /cars           cars#create
# GET    /cars/new       cars#new
# GET    /cars/:id/edit    cars#edit
# GET    /cars/:id      cars#show
# PATCH  /cars/:id     cars#update
# PUT    /cars/:id      cars#update
# DELETE /cars/:id      cars#destroy

# GET    /bookings        bookings#index
# POST   /bookings        bookings#create
# GET    /bookings/new     bookings#new
# GET    /bookings/:id/edit   bookings#edit
# GET    /bookings/:id     bookings#show
# PATCH  /bookings/:id      bookings#update
# PUT    /bookings/:id     bookings#update
# DELETE /bookings/:id      bookings#destroy

# POST   /booking/:booking_id/reviews     reviews#create
# GET    /bookings/:booking_id/reviews/new reviews#new
# DELETE /reviews/:id           reviews#destroy
