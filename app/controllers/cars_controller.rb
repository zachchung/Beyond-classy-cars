class CarsController < ApplicationController
  skip_before_action :authenticate_user!, only: :index # no need login on /cars page

  def new
    @car = Car.new
  end

  def create
    @car = Car.new(car_params)
    @car.user = current_user
    if @car.save
      redirect_to car_path(@car)
    else
      render :new
    end
  end

  def show
    @car = Car.find(params[:id])
    @booking = Booking.new
    @reviews = @car.reviews
    @markers = markers_for_one_car(@car) # 1 car/ info_window
  # alert & redirect if page not found
  rescue ActiveRecord::RecordNotFound => e
    redirect_to cars_path, notice: "Could not find the car you requested."
  end

  def index
    @geocoded_cars = Car.geocoded # returns cars with coordinates (instead of- @cars = Car.all)

    # From search form @root_path (/cars?location=losangeles&model=bmw&commit=Search) ================
    location = params[:location]
    model = params[:model]

    if location.present? && model.present? # both location & model search
      @cars = @geocoded_cars.search_by_name_and_location(location).search_by_name_and_location(model)
    elsif location.present? && !model.present? # only location search
      @cars = @geocoded_cars.search_by_name_and_location(location)
    elsif !location.present? && model.present? # only model search # .nil? / .empty? give errors... need to use !.present?
      @cars = @geocoded_cars.search_by_name_and_location(model)
    else # if no search
      @cars = @geocoded_cars
    end
    # End of search => returns @cars ====================================================================

    # For info_window (need all locations):
    @locations = []
    @cars.each { |car| @locations << car.location } # get all locations (instead of cars)
    @markers = markers_for_many_locations(@locations) # 1 location/ info_window
  end

  def destroy
    @car = Car.find(params[:id])

    if @car.bookings.count.zero?
      @car.destroy
      redirect_to listmycars_cars_path
    else
      redirect_to listmycars_cars_path, alert: "Car cannot be removed. There are still bookings for this car."
    end
  end

  def edit
    @car = Car.find(params[:id])
  end

  def update
    @car = Car.find(params[:id])
    @car.update(car_params)
    redirect_to listmycars_cars_path
  end

  def listmycars
    @cars = current_user.cars
  end

  private

  # For "/cars": 1 location/ info_window:
  def markers_for_many_locations(locations)
    locations.map do |location|
      cars = Car.where(location: location) # 1 location can have many cars
      {
        lat: cars.first.latitude,
        lng: cars.first.longitude,
        infoWindow: render_to_string(partial: "info_window", locals: { cars: cars }), # send "cars" (array) to info_window
        image_url: helpers.asset_url('ferrari.png')
      }
    end
  end

  # For "/car/15": 1 car/ info_window:
  def markers_for_one_car(car)
    [{
      lat: car.latitude,
      lng: car.longitude,
      infoWindow: render_to_string(partial: "info_window", locals: { car: car }), # send "car" (object) to info_window
      image_url: helpers.asset_url('ferrari.png')
    }] # need to pass an array [] here (coz mapbox.js expect markers to be an array -> markers.forEach)!!!!
  end

  def car_params
    params.require(:car).permit(:name, :location, :seats, :year, :price, photos: [])
  end
end
