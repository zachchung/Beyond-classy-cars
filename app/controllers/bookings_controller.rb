class BookingsController < ApplicationController

  booking_status = %w[pending confirmed cancelled returned renting]

  def new; end

  def create
    @booking = Booking.new(booking_params)
    @booking.status = "pending"
    # issues if booking dates are not valid, need to redirect_to show page again
    if @booking.save
      redirect_to @booking
    else
      # this render :new will render a new confirmation page
      render :new
    end
  end

  def index
    @bookings = Booking.where(user: current_user)
  end

  def show
    @booking = Booking.find(params[:id])
    @days = (@booking.end_date.day - @booking.start_date.day).to_i
    # @days = ((@booking.end_date - @booking.start_date) / 60 / 60 / 24).to_i
    @booking_price = (@booking.car.price * @days).round(2)
  end

  private

  def booking_params
    params.require(:booking).permit(:start_date, :end_date, :car_id, :user_id)
  end
end
