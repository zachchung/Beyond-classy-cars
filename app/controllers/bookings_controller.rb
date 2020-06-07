class BookingsController < ApplicationController
  before_action :booking_set, only: [:show, :modify, :approve, :decline, :cancel]

  def new
    @booking = Booking.new
  end

  def create
    @booking = Booking.new(booking_params)
    @booking.status = "pending"
    @booking.booking_price = (@booking.car.price * @booking.duration).round(2)

    if @booking.save
      redirect_to @booking
    else
      redirect_to car_path(@booking.car), alert: "Dates are not available!"
      # render html: "<script>alert('Dates are not available!')</script>".html_safe
      # redirect_to car_path(@booking.car), alert: @booking.errors['dates'].first
    end
  end

  def index
    @bookings = Booking.where(user: current_user)
  end

  def show
    redirect_to bookings_path, notice: "Booking is not found." unless belongs_to_user?
    # so cannot see other user's bookings
  end

  def approve
    # redirect_to listmycars_cars_path, notice: "Booking is not found." unless belongs_to_user?
    if @booking.approved!
      redirect_to listmycars_cars_path, notice: "Booking ##{@booking.id} is approved!"
    else
      redirect_to listmycars_cars_path, notice: "Sorry please try again"
    end
  end

  def decline
    if @booking.declined!
      redirect_to listmycars_cars_path, notice: "Booking ##{@booking.id} is declined!"
    else
      redirect_to listmycars_cars_path, notice: "Sorry please try again"
    end
  end

  def cancel
    if @booking.cancelled!
      redirect_to bookings_path, notice: "Booking ##{@booking.id} is cancelled!"
    else
      redirect_to bookings_path, notice: "Sorry please try again"
    end
  end

  private

  def booking_set
    @booking = Booking.find(params[:id])
  end

  def booking_params
    params.require(:booking).permit(:start_date, :end_date, :car_id, :user_id)
  end

  def belongs_to_user?
    @booking.car.user == current_user || current_user.booking_ids.include?(@booking.id) # ??????????
  end
end
