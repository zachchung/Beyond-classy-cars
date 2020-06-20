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
    @markers = markers_for_one_car(@car)
  # alert & redirect if page not found
  rescue ActiveRecord::RecordNotFound => e
    redirect_to cars_path, notice: "Could not find the car you requested."
  end

  def index
    @geocoded_cars = Car.geocoded # returns cars with coordinates (instead of- @cars = Car.all)

    # From root_path (/cars?location=losangeles&model=bmw&commit=Search)

    location = params[:location]
    model = params[:model]

    if location.present? && model.present? # both location & model search
      @cars = @geocoded_cars.search_by_name_and_location(location).search_by_name_and_location(model)
    elsif location.present? && model.nil? # only location search
      @cars = @geocoded_cars.search_by_name_and_location(location)
    elsif location.nil? && model.present? # only model search
      @cars = @geocoded_cars.search_by_name_and_location(model)
    else # if no search
      @cars = @geocoded_cars
    end

    @markers = markers_for_many_cars(@cars)
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

  def markers_for_many_cars(cars)
    cars.map do |car|
      {
        lat: car.latitude,
        lng: car.longitude,
        infoWindow: render_to_string(partial: "info_window", locals: { car: car }),
        image_url: helpers.asset_url('ferrari.png')
      }
    end
  end

  def markers_for_one_car(car)
    [{
      lat: car.latitude,
      lng: car.longitude,
      infoWindow: render_to_string(partial: "info_window", locals: { car: car }),
      image_url: helpers.asset_url('ferrari.png')
    }] # need to pass an array [] here (coz mapbox.js expect markers to be an array -> markers.forEach)!!!!
  end

  def car_params
    params.require(:car).permit(:name, :location, :seats, :year, :price, photos: [])
  end
end
